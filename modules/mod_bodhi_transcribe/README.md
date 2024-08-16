# mod_bodhi_transcribe

A Freeswitch module that generates real-time transcriptions on a Freeswitch channel by using Bodhi's streaming transcription API

## API

### Commands

The freeswitch module exposes the following API commands:

```
uuid_bodhi_transcribe <uuid> start <model-name>
```

Attaches media bug to channel and performs streaming recognize request.

- `uuid` - unique identifier of Freeswitch channel
- `model-name` - a valid bodhi model-name

```
uuid_bodhi_transcribe <uuid> stop
```

Stop transcription on the channel.

### Channel Variables

- Add this variables in vars.xml or include in session before starting trascription

| variable          | Description                            |
| ----------------- | -------------------------------------- |
| BODHI_API_KEY     | Bodhi API key used to authenticate     |
| BODHI_CUSTOMER_ID | Bodhi Customer Id used to authenticate |

### Events

`bodhi_transcribe::transcription` - returns an interim and final transcription. The event contains a JSON body describing the transcription result:

```js
{
  "call_id": "<CALL_UUID>",
  "segment_id": "<SENTENCE_SEGMENT_ID>",
  "eos": false,
  "type": "partial" _// "complete",_
  "text": "<TRANSCRIPT>"
}
```

### How to use POC

- Copy build file from [/poc](/poc) folder to ~/freeswitch/mod/ directory.
- Copy all files from [/poc/scripts](/poc/scripts) to ~/freeswitch/scripts directory.
- Add Auth variables in `~/freeswitch/conf/vars.xml` file
- Add bodhi module to modules configuration `~/freeswitch/conf/autoload_configs/modules.conf.xml`

```bash
<load module="mod_bodhi_transcribe"/>
```

- Add Dialplan to run lua file `~/freeswitch/dialplan/default.xml`

```xml
<condition field="destination_number" expression="^8000$">
    <action application="answer"/>
    <action application="log" data="Call connected successfully!" event="info"/>
    <action application="lua" data="~/freeswitch/scripts/bodhi_transcribe.lua"/>
</condition>
```

- Run dummy call using following command

```bash
fs_cli
reloadxml
originate {origination_caller_id_number=9090909090}loopback/8000/default &echo()
```

> **Note:** Change ~/freeswitch with actual path of freeswitch directory

### Available ASR Models for Testing

- **Bengali:** `bn-general-jan24-v1-8khz`
- **Hindi:** `hi-general-feb24-v1-8khz`
- **Kannada:** `kn-general-jan24-v1-8khz`
- **Marathi:** `mr-general-jan24-v1-8khz`
- **Tamil:** `ta-general-jan24-v1-8khz`
- **Telugu:** `te-general-jan24-v1-8khz`
