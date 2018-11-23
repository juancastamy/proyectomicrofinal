from tkinter import *
from time import sleep
ventana = Tk()
Text=StringVar()

import serial
import time
import sys

ser= serial.Serial(port='COM10', baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, bytesize=serial.EIGHTBITS, timeout=0)



ventana.title('Usando botones')

numPWM=[]
numPWM1=[]
numPWM=numPWM[:5]
if len(numPWM)>5:
    raise Exception("Cantidad de datos mayor a lo permitido")

#texto
DATOI=Label(ventana, text="dato")
DATOI.grid(row=1, column=1, padx=10, pady=10)

DATO1=Label(ventana, text="servo1")
DATO1.grid(row=2, column=1, padx=10, pady=10)

DATO2=Label(ventana, text="servo2")
DATO2.grid(row=3, column=1, padx=10, pady=10)

DATO3=Label(ventana, text="servo3")
DATO3.grid(row=4, column=1, padx=10, pady=10)

DATO4=Label(ventana, text="servo4")
DATO4.grid(row=5, column=1, padx=10, pady=10)

#botpon
def leer():
    numPWM.clear()
    
    numPWM.append(ser.read(1))
    numPWM.append(ser.read(1))
    numPWM.append(ser.read(1))
    numPWM.append(ser.read(1))
    
    =ord(numPWM[0])
    caja1=Label(ventana, textvariable=serv1)
    caja1.grid(row=2, column=3, padx=10, pady=10)

    serv2=ord(numPWM[1])
    caja2=Label(ventana, textvariable=serv2)
    caja2.grid(row=3, column=3, padx=10, pady=10)

    serv3=ord(numPWM[2])
    caja3=Label(ventana, textvariable=serv3)
    caja3.grid(row=4, column=3, padx=10, pady=10)

    serv4=ord(numPWM[3])
    caja4=Label(ventana, textvariable=serv4)
    caja4.grid(row=5, column=3, padx=10, pady=10) 
    
    print(numPWM)

READ=Button(ventana, text="leer", command=leer)
READ.grid(row=7, column=5, padx=10, pady=10)

def enviar():
    #bytes, int, float???
    
    ser.write((numPWM[0]))
    time.sleep(.2)
    ser.write((numPWM[1]))
    time.sleep(.2)
    ser.write((numPWM[2]))
    time.sleep(.2)
    ser.write((numPWM[3]))
    print("Enviado")
    print(numPWM)
    #numPWM.clear()
    
btnSEND=Button(ventana, text="enviar.", command=enviar)
btnSEND.grid(row=7, column=7, padx=10, pady=10, bg='green')

def guardar():

    numPWM1.append(ser.read())
    numPWM1.append(ser.read())
    numPWM1.append(ser.read())
    numPWM1.append(ser.read())
    
    dat1=numPWM1[0]
    cajag1=Label(ventana, textvariable=dat1)
    cajag1.grid(row=2, column=5, padx=10, pady=10)
    
    dat2=numPWM1[1]
    cajag2=Label(ventana, textvariable=dat1)
    cajag2.grid(row=2, column=5, padx=10, pady=10)

    dat3=numPWM1[2]
    cajag3=Label(ventana, textvariable=dat1)
    cajag3.grid(row=2, column=5, padx=10, pady=10)

    dat4=numPWM1[3]
    cajag4=Label(ventana, textvariable=dat1)
    cajag4.grid(row=7, column=5, padx=10, pady=10)



    
    #bytes, int, float???
    
    print(numPWM1)

    
SAVE=Button(ventana, text="guardar", command=guardar)
SAVE.grid(row=7, column=9, padx=10, pady=10, bg='blue')

def enviar_guardado():
    ser.write(numPWM1[0])
    time.sleep(.2)
    ser.write(numPWM1[1])
    time.sleep(.2)
    ser.write(numPWM1[2])
    time.sleep(.2)
    ser.write(numPWM1[3])
    time.sleep(.2)
    print("Enviado")
    print(numPWM1)
    numPWM1.clear()

btnSS=Button(ventana, text="ENVIAR GUARDADO", command=enviar_guardado)
btnSS.grid(row=7, column=11, padx=10, pady=10, bg='red')
