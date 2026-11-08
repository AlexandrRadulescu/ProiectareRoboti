# Proiectare Roboți: Robot Design Project

University project for the **Proiectarea Roboților** (Robot Design) course at **Universitatea Transilvania din Brașov**, Robotics programme, 2026/2027.

> **Status: work in progress (Viza 2 of 4).**
> This repository holds the project at its second review stage. It is not finished. The complete project will be ready at **Viza 4**.

## Contents

| Folder / file | Description |
| --- | --- |
| `Objects/` | CATIA V5 3D models: robot links, assembly, load (paralelipiped) and gripper sub-assembly |
| `Objects/Gripper/` | Third-party SCHUNK EGU 80 gripper model (see [Third-party content](#third-party-content)) |
| `Objects/MODUL 2/` | Module II (rotation) design: housing, cover, flanges, fixing ring |
| `Objects/MODUL 2/COMPONENTE/` | Module II components, including third-party motor and gear unit models (see [Third-party content](#third-party-content)) |
| `Objects/FULL/` | Full robot assembly |
| `Models/` | MATLAB / Simulink model (`V0.slx`) |
| `Models/Profile/` | MATLAB scripts for motion profiles (`profil_R.m`, `profil_T.m`) |
| `Photos/` | Images used in the report |
| `Memoriu tehnic PrRo.docx` | Technical report (memoriu tehnic) |

## Tools

- CATIA V5
- MATLAB / Simulink (R2025a)
- Microsoft Word

## Author

Alexandru Rădulescu, Group 2

Coordinators: Prof. univ. dr. ing. Gheorghe Mogan, Asist. drd. Diana Buzdugan

## Media

<img width="1280" height="720" alt="2026-11-05 19-09-34" src="https://github.com/user-attachments/assets/001eac6d-39f3-4810-92ea-dd1e1733e220" />


## Third-party content

The following manufacturer CAD models are **not** covered by this project's license. All rights remain with their respective owners. They are included unmodified, only so the assemblies can be opened, and are used here for non-commercial educational purposes. Product names and trademarks belong to their owners.

### SCHUNK EGU 80 gripper (`Objects/Gripper/`)

Distributed under the [Creative Commons Attribution-NoDerivatives 4.0 (CC BY-ND 4.0)](https://creativecommons.org/licenses/by-nd/4.0/) license:

- **CADENAS GmbH** holds the rights to the database in the form of the CAD file.
- **SCHUNK SE & Co. KG** holds the rights to the original component.

Source: [3Dfindit.com / PARTcommunity](https://www.3dfindit.com/) by CADENAS. See [`Objects/Gripper/license_schunk.txt`](Objects/Gripper/license_schunk.txt).

### Beckhoff AM8032 servomotor (`Objects/MODUL 2/COMPONENTE/`)

- Files: `AM8032-xx01.stp`, `AM8032-xx01.CATProduct`, `Intercontec-EEDC101NN00000006000.CATPart`
- © **Beckhoff Automation GmbH & Co. KG**. The connector model (Intercontec, now part of **TE Connectivity**) is included in the Beckhoff motor model.
- Source: [beckhoff.com](https://www.beckhoff.com/)

### Harmonic Drive CSG-32 gear unit (`Objects/MODUL 2/COMPONENTE/`)

- Files: `CSG-32-XXX-2A-GR.stp`, `CSG-32-XXX-2A-GR.CATPart`
- © **Harmonic Drive SE**. Harmonic Drive® is a registered trademark of Harmonic Drive SE.
- Source: [harmonicdrive.de](https://harmonicdrive.de/)

If you are a rights holder and want a file removed, please open an issue and it will be taken down.

## License

Except for the third-party content listed above, this project is licensed under [CC BY 4.0](LICENSE).
