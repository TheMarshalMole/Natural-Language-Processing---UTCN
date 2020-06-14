
import datetime

TIME_INCREMENT = 1

def getEventFormat(name = None, data = None, timeStart = None, timeEnd = None):
  if timeStart == None:
    timeStart = "00:00"
    timeEnd = "23:59"
  elif timeEnd == None:
    timeEnd = timeStart.split(":")
    timeEnd = "{}:{}:00.000".format(int(timeEnd[0]) + TIME_INCREMENT, timeEnd[1])
  
  timeEnd = "{}:00.000".format(timeEnd)
  timeStart = "{}:00.000".format(timeStart)

  # convertim timpul
  timeStart = "{}T{}".format(data, timeStart)
  timeEnd = "{}T{}".format(data, timeEnd)
  print(timeStart, timeEnd)
  returnValue =  {
    'summary': name,
    'start': {
      'dateTime': timeStart,
      'timeZone': 'Europe/Bucharest',
    },
    'end': {
      'dateTime': timeEnd,
      'timeZone': 'Europe/Bucharest',
    }

  }
  return returnValue

