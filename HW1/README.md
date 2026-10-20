# Computer Graphics Lab 1

## 一、作業內容

這次作業主要是利用 Processing 提供的程式架構，實作畫線、畫圓、畫橢圓、Bézier 曲線以及橡皮擦的功能。

### 已完成功能

- CGLine：直線（也會用在 Polygon 和 Pencil）
- CGCircle：圓形
- CGEllipse：橢圓形
- CGCurve：Bézier 曲線
- CGEraser：橡皮擦

## 二、實作方式

### 1. CGLine — Midpoint Line Algorithm

先用 `dx`、`dy` 判斷直線主要往 x 還是 y 方向移動，再根據判斷值 `d` 決定下一步要畫哪個點。使用 `sx`、`sy` 處理不同方向的直線，就不用分成八種情況寫。

因為使用 `!=` 判斷是否到終點，所以先把座標用 `round()` 轉成整數，避免無法結束迴圈。

### 2. CGCircle — Midpoint Circle Algorithm

從 `(0, R)` 開始，根據 `d` 決定下一步選 E 還是 SE，再利用圓的八向對稱畫出其他點，這樣就不用整個圓都重新計算。

### 3. CGEllipse — Midpoint Ellipse Algorithm

橢圓分成兩個區域處理。Region 1 主要往 x 方向移動，依照 `d1` 選 E 或 SE；Region 2 主要往 y 方向移動，依照 `d2` 選 S 或 SE。每次都利用四向對稱畫出其他點。

### 4. CGCurve — Cubic Bézier Curve

利用四個控制點及 Bézier Curve 公式計算曲線上的位置，讓 `t` 從 0 變化到 1，再將算出的點畫出來。取樣次數會參考控制點之間的總距離，讓曲線比較不容易出現空隙。

### 5. CGEraser — 橡皮擦

先找出兩個點所形成的矩形範圍，再用兩層 `for` 迴圈把範圍內的點畫成背景色 `color(250)`，就能達到擦除的效果。

## 三、BONUS（選做）

這次作業的 BONUS 是新增原本沒有提供的繪圖功能，例如調色盤、其他圖形或噴漆功能。

目前尚未另外實作 BONUS 功能。

## 四、實作過程與 AI 使用說明

這次我是先跟著課堂講義和參考資料理解演算法，再自己實作一次。遇到不太懂的公式或判斷方式時，會再查資料或詢問 ChatGPT，也有請它用簡單的座標例子模擬每一步怎麼選點、判斷值怎麼改變，讓我更清楚 Midpoint 和 Bézier Curve 的作圖原理。

初步完成後，我把程式提供給 ChatGPT，請它幫忙檢查有沒有遺漏或寫錯的地方，也請它協助補上簡短的程式註解，以及整理這份 README。例如直線原本使用 `while (x != endX)`，討論後發現非整數座標可能無法剛好走到終點，所以後來加上 `round()`。

整體還是以自己參考講義後實作的版本為主，再透過 AI 協助理解、檢查與調整。

## 五、執行結果

### 1. 直線（Line）

<img width="800" height="663" alt="image" src="https://github.com/user-attachments/assets/168d19c3-fabe-4596-abc7-752cc768b385" />

### 2. 圓形（Circle）

<img width="798" height="664" alt="image" src="https://github.com/user-attachments/assets/418f0a68-7e9b-4325-aecf-b9f9e792033d" />

### 3. 橢圓形（Ellipse）

<img width="798" height="663" alt="image" src="https://github.com/user-attachments/assets/811dd00e-e7cc-4523-abf9-d9003ef2dcc2" />

### 4. Bézier 曲線（Curve）

<img width="797" height="661" alt="image" src="https://github.com/user-attachments/assets/9f80262e-a6a7-4eb9-b4e9-a8ac0c053893" />

### 5. 橡皮擦（Eraser）

<img width="796" height="662" alt="image" src="https://github.com/user-attachments/assets/a2d0f06b-8005-4df5-bdf8-449faba34a2f" />

## 六、參考資料

- 課堂講義：Midpoint Line、Midpoint Circle、Midpoint Ellipse、Bézier Curve
- [CG Lab 1 作業說明的橢圓參考連結] https://www.geeksforgeeks.org/midpoint-ellipse-drawing-algorithm/
- [CG Lab 1 作業說明的曲線參考連結] https://javascript.info/bezier-curve
