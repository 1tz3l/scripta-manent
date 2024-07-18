## scripta-manent

# Descripción
DApp que te permite publicar tus obras en la blockchain de Aptos.

Su nombre proviene de la frase en latín "verba volant, scripta manent", que significa "las palabras vuelan, los escritos permanecen"*.

*Fuente:https://cvc.cervantes.es/lengua/refranero/Ficha.aspx?Par=58935&Lng=14



## Instalación de Aptos CLI 

Fuente: https://github.com/Zona-Tres/aptos-first-steps?tab=readme-ov-file#instalaci%C3%B3n-de-la-aptos-cli

Para poder interactuar con el contenido, es necesario instalar **Aptos CLI**.

1. [Instalación en Linux](#linuxcli)
2. [Instalación en Mac](#maccli)
3. [Instalación en Windows](#windowscli)



## Instalación en Linux <a id="linuxcli"></a>

1. Asegúrate de tener instalado **Python** 3.6 o superior. Para esto puedes abrir una terminal y correr el siguiente comando:
```
python3 --version
```

Si el comando anterior arroja un error, es necesario instalar **Python**. Si estás usando Ubuntu, y sólo quieres instalar la versión necesaria, puedes correr los siguientes comandos:
```sh
sudo apt update
sudo apt install python3.6
```

Si en vez de lo anterior, deseas personalizar tu instalación o instalar la versión más reciente de Python, puedes hacerlo desde la página oficial: [https://www.python.org/](https://www.python.org/).

2. Una vez instalado Python, correr el siguiente comando:
```sh
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
```
> :information_source: Si el comando de arriba da error, es necesario instalar `curl`. Puedes hacerlo con los siguientes comandos:
> ```sh
> sudo apt update
> sudo apt install curl
>```

3. Verifica la instalación utilizando:
```sh
aptos help
```

> :information_source: Si el comando de arriba da error, simplemente cierra tu terminal, ábrela de nuevo y vuelve a intentar.



## Instalación en Mac <a id="maccli"></a>

1. Asegúrate de tener **Homebrew** instalado: [https://brew.sh/](https://brew.sh/).
2. Abre una terminal e introduce los siguientes comandos:
```sh
brew update
brew install aptos
```
3. Abre otra terminal y ejecuta el comando `aptos help` para verificar que la instalación fue correcta:
```sh
aptos help
```
### Actualizar la CLI
Actualizar la CLI con `brew` requiere de 2 comandos:
```sh
brew update
brew upgrade aptos
```


## Instalación en Windows <a id="windowscli"></a>

Para la instalación en **Windows** vamos a utilizar **Python**.

> :information_source: ***Importante***: En Widows es necesario utilizar **PowerShell** para ejecutar los comandos. **No** utilices `cmd`.

1. Asegúrate de tener instalado **Python** 3.6 o superior. Para esto puedes abrir una terminal y correr el siguiente comando:
```
python3 --version
```

Si el comando anterior arroja un error, es necesario instalar **Python**. Puedes hacerlo desde: [https://www.python.org/](https://www.python.org/).

2. Una vez instalado Python, correr el siguiente comando:

```powershell
iwr "https://aptos.dev/scripts/install_cli.py" -useb | Select-Object -ExpandProperty Content | python3
```
> :warning: Si recibes un error como `ModuleNotFoundError: No module named packaging` puedes instalar la herramienta faltante `packaging` usando el comando: 
> ```powershell
> pip3 install packaging
> ```

3. Una vez finalizada la instalación, deberías ver un mensaje diciendo `Execute the following command to update your PATH:`. Y un comando como este:

```powershell
setx PATH "%PATH%;C:\Users\<your_account_name>\.aptoscli\bin"
```

> :warning: **NO EJECUTES ESTE COMANDO**. El uso de las comillas dobles en `%PATH%` puede causar que el valor actual de `PATH` no se expanda correctamente, lo que lleva a la sobrescritura del `PATH` en lugar de su extensión.

Te recomiendo usar el siguiente comando en vez del anterior:

```powershell
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\<your_account_name>\.aptoscli\bin", "User")
```

> :information_source: Recuerda sustituir `<your_account_name>` con el nombre real de tu cuenta en Windows. Si no sabes cuál es, puedes obtenerlo con el siguiente comando:
> ```powershell
> $env:USERNAME
> ```

4. Finalmente, valida tu instalación corriendo:
```powershell
aptos help
```



## Interactuando con el repositorio.

El repositorio está compuesto de una carpeta llamada `scripta-manent`, simplemente navega a ella usando `cd`. Ejemplo: `cd script-manent`.
> :information_source: Recuerda que cd se utiliza en Linux.


## Ejecutando el contenido.

> :information_source: Recuerda que debes navegar en tu terminal a este directorio:
>```sh
>cd scripta-manent
>```

Ingresa a tu terminal y ejecuta el siguiente comando:

```sh
aptos move test
```

Deberías de obtener el siguiente resultado:
```sh
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING Book
Running Move unit tests
Test result: OK. Total tests: 0; passed: 0; failed: 0
{
  "Result": "Success"
}
```

> :information_source: No te preocupes si te llega a salir una advertencia (warning) como esta:
```
warning[W09001]: unused alias
  ┌─
  │
2 │     use std::string::{Self, String, utf8};
  │              ^^^^^^ Unused 'use' of alias 'string'. Consider removing it
```

Y de esta forma se ejecuta un módulo Move.

</br></br>
