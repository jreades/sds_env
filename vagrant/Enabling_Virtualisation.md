# How to enable the Virtualisation on your Windows machine.

During the [installation of Vagrant](https://github.com/jreades/sds_env/tree/master/vagrant), it is possible that you may encounter an error telling you that: `VT-x is disabled`or referencing a problem with AMD-V if you have an AMD CPU.

The error could appear like this:

> Stderr: VBoxManage.exe: error: Not in a hypervisor partition (HVP=0) (VERR_NEM_NOT_AVAILABLE).*  
> *VBoxManage.exe: error: VT-x is disabled in the BIOS for all CPU modes (VERR_VMX_MSR_ALL_VMX_DISABLED)*  
> *VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component ConsoleWrap, interface IConsole*

This means that the hardware acceleration settings required by the CPU to support **virtualisation** are **currently disabled** in your BIOS.  

**Accessing the BIOS settings** may require different steps according to the manufacturer/model/age of your computer. Usually, when you restart your machine you will have to press a key combination to ‘enter setup’ before your computer starts loading the Operating System (i.e. in the first few seconds after turning on your machine).  


Here is a list of instructions on how to access the BIOS settings for different computer manufacturers (you can find the full article [here](https://2nwiki.2n.cz/pages/viewpage.action?pageId=75202968)):

### Acer
Most commonly: press `F2` or `Delete`. On older computers it was `F1` or the key combination `CTRL+ALT+ESC`.  
- Turn **ON** the System.  
- Press **F2** key at startup BIOS Setup.
- Press the right arrow key to **System Configuration** tab, select **Virtualization Technology** and then press the **Enter** key.
- Select **Enabled** and press the **Enter** key.
- Press the **F10** key, select **Yes** and press the **Enter** key to save changes and **Reboot** into Windows.
---

### Asus
Most commonly: press `F2`, but may also be the `Delete` or `Insert` key, and less commonly `F10`.
- Turn **ON** the System.
- Press **F2** key at startup BIOS Setup.
- Press the right arrow key to **Advanced** tab, select **Virtualization Technology** and then press the **Enter** key.
- Select **Enabled** and press the **Enter** key.
- Press the **F10** key, select **Ye**s and press the **Enter** key to save changes and **Reboot** into Windows.
---

### DELL
Newer models: `F2` key whilst the Dell logo is visible on the screen. May also be: `F1`, `Delete`, `F12`, or `F3`.  Older models: `CTRL+ALT+ENTER` or `Delete` or `Fn+ESC` or `Fn+F1`.  
- Turn **ON** the System.
- Press **F2** key at startup BIOS Setup.
- Press the right arrow key to **Advanced** tab, select **Virtualization** and then press the **Enter** key.
- Select **Enabled** and press the **Enter** key.
- Press the **F10** key, select **Yes** and press the **Enter** key to save changes and **Reboot** into Windows.
---

### HP
Most commonly: `F10` or `ESC`. May also be: `F1`, `F2`, `F6`, or `F11`. On HP Tablet PCs: `F10` or `F12`  
- Turn **ON** the System
- Repeatedly press **Es**c key at startup.
- Press the **F10** key for BIOS Setup.
- Press the right arrow key to **System Configuration** tab, Select **Virtualization Technology** and then press the **Enter** key.
- Select **Enabled** and press the **Enter** key.
- Press the **F10** key, select **Yes** and press the **Ente**r key to save changes and **Reboot**.
---

### Lenovo
Most commonly: `F1` or `F2`. Older hardware:`CTRL+ALT+F3` or `CTRL+ALT+INS` or `Fn+F1`. If you have a ThinkPad, consult this Lenovo resource: [how to access the BIOS on a ThinkPad](https://support.lenovo.com/us/en/solutions/HT500222#2).  

**Enabling VT-x in ThinkPad (Tablets/Convertibles/Notebooks):**
- Power **ON** the system.
- Press **Enter** or **Tap** the touch screen during Lenovo startup screen.
- Press or Tap **F1** to enter into BIOS Setup.
- Navigate to **Security** tab, then press **Enter** on **Virtualization**.
- Select Intel(R) **Virtualization Technology**, press **Enter**, choose **Enable** and press **Enter**.
- Press **F10**.
- Press Enter on **YES** to save the settings and boot into Windows.


**Enabling VT-x in ThinkCentre (Desktops):**
- Power **ON** the system.
- Press **Enter** during Lenovo startup screen.
- Press **F1** key to enter into BIOS Setup.
- Navigate to the **Advanced** tab and press **Enter** on **CPU Setup**.
- Select Intel(R) **Virtualization Technology**, press **Enter**, choose **Enable** and press **Enter**.
- Press **F1**0.
- Press Enter on **YES** to save the settings and boot into Windows.
---

### Sony
Sony VAIO: `F2` or `F3` May also be `F1`.  If your VAIO has an `ASSIST` key, try to press and hold it while you power on the laptop. This also works if your Sony VAIO came with Windows 8.
- With the computer turned completely off, press and hold the **Assist** button until the black VAIO screen appears. 
**NOTE**: The location of the **Assist** button will be different depending on the computer model. Refer to the operating instructions supplied with the computer for the exact location of the Assist button on your model.
- At the **VAIOCare | Rescue Mode** screen, press the **Down Arrow** key until the **Start BIOS setup [F2]** option is highlighted, and then press the **Enter** key.
- In the **[BIOS Name] Setup Utility** screen, press the right-arrow key until the **Advanced** tab is selected.
- On the **Advanced** tab, press the down-arrow key until **Intel(R) Virtualization Technology** is selected and then press the **Enter** key. 
- Use the arrow keys to select **Enabled** and then press the **Enter** key.
- Press the right-arrow key until the **Exit** tab is selected.
- Press the down-arrow key until **Exit Setup** is selected and then press the **Enter** key.
- In the **Save** screen, verify **Yes** is selected and then press the **Enter** key.
---

### Toshiba
Most commonly: `F2` key. Alternatively: `F1` and `ESC`.  Toshiba Equium: `F12`.
- Turn **ON** the System.
- Press **F2** key at startup BIOS Setup.
- Press the right arrow key to **Advanced** tab, select **Virtualization Technology** and then press the **Enter** key.
- Select **Enabled** and press the **Enter** key.
- Press the **F10** key and select **Yes** and press the **Enter** key to save changes and **Reboot** into Windows.
---

Once you'll have enabled the Virtualisation Technology, you can go back to the Vagrant installation and try it another time. This time it will (hopefully!) work just fine.
