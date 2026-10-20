# Computer Graphics Lab 1

## 1. Assignment Overview

This assignment uses the Processing framework to implement basic drawing functions, including lines, circles, ellipses, Bézier curves, and an eraser. I also added a Spray tool as a BONUS feature.

### Completed Features

- CGLine: Line drawing (also used in Polygon and Pencil)
- CGCircle: Circle drawing
- CGEllipse: Ellipse drawing
- CGCurve: Bézier curve
- CGEraser: Eraser

## 2. Implementation

### 1. CGLine — Midpoint Line Algorithm

First, `dx` and `dy` are used to determine whether the line moves mainly along the x-axis or y-axis. Then, the decision parameter `d` is used to choose the next point. The variables `sx` and `sy` are used to handle different drawing directions, so there is no need to implement all eight octants separately.

Since `!=` is used to check whether the endpoint has been reached, I used `round()` to convert the coordinates into integers to prevent the loop from running indefinitely.

### 2. CGCircle — Midpoint Circle Algorithm

Starting from `(0, R)`, the decision parameter `d` determines whether to choose E or SE. The eight-way symmetry of a circle is then used to draw the remaining points, so there is no need to calculate every point separately.

### 3. CGEllipse — Midpoint Ellipse Algorithm

The ellipse is divided into two regions. Region 1 mainly moves along the x-axis and uses `d1` to choose E or SE, while Region 2 mainly moves along the y-axis and uses `d2` to choose S or SE. Four-way symmetry is used to draw the remaining points.

### 4. CGCurve — Cubic Bézier Curve

The Bézier curve formula and four control points are used to calculate positions along the curve. The value of `t` changes from 0 to 1, and each calculated point is drawn on the screen. The number of sampling steps is based on the total distance between the control points to reduce gaps between points.

### 5. CGEraser — Eraser

First, the rectangular area defined by two points is calculated. Then, two nested `for` loops are used to change all points within the area to the background color `color(250)`, creating the erasing effect.

## 3. BONUS — Spray

For the BONUS, I chose to add a Spray tool that allows users to draw randomly distributed dots on the canvas using the mouse.

The main idea is to use `random()` to generate random coordinates around the mouse position. The circle equation `dx² + dy² <= r²` is then used to check whether each point is within the spray range. Finally, `drawPoint()` is used to draw the valid points.

I also followed the structure of the original Pencil tool and added `SprayRenderer` to handle mouse interactions. A `Spray` class is used to store the coordinates of the sprayed points, so the drawing remains visible after releasing the mouse. The original Undo and Clear functions can also be used.

## 4. Implementation Process and AI Usage

For this assignment, I first followed the lecture slides and reference materials to understand the algorithms, and then tried implementing them myself. When I had questions about the formulas or decision conditions, I searched for additional information or asked ChatGPT. I also used ChatGPT to simulate the drawing process with simple coordinate examples, showing how the next point is selected and how the decision parameter changes. This helped me better understand the Midpoint algorithms and Bézier curves.

After completing the initial implementation, I provided my code to ChatGPT to check for possible mistakes or missing parts. I also asked it to help add simple code comments and organize this README. For example, I originally used `while (x != endX)` for line drawing. After discussing it with ChatGPT, I realized that non-integer coordinates might prevent the loop from reaching the exact endpoint, so I added `round()`.

For the BONUS, I first discussed with ChatGPT which additional feature would be easier to implement and eventually chose the Spray tool. Since this feature needed to work with the existing program structure, I asked ChatGPT where to add the button and how to implement the function. I also referred to the code provided by AI and tried to understand the purpose of each part and the underlying principles.

Overall, the main drawing functions were implemented based on my understanding of the lecture materials, with AI assisting in understanding, checking, and improving the code. I relied more on AI assistance for the BONUS feature.

## 5. Results

### 1. Line

<img width="800" height="663" alt="Line" src="https://github.com/user-attachments/assets/168d19c3-fabe-4596-abc7-752cc768b385" />

### 2. Circle

<img width="798" height="664" alt="Circle" src="https://github.com/user-attachments/assets/418f0a68-7e9b-4325-aecf-b9f9e792033d" />

### 3. Ellipse

<img width="798" height="663" alt="Ellipse" src="https://github.com/user-attachments/assets/811dd00e-e7cc-4523-abf9-d9003ef2dcc2" />

### 4. Bézier Curve

<img width="797" height="661" alt="Bézier Curve" src="https://github.com/user-attachments/assets/9f80262e-a6a7-4eb9-b4e9-a8ac0c053893" />

### 5. Eraser

<img width="796" height="662" alt="Eraser" src="https://github.com/user-attachments/assets/a2d0f06b-8005-4df5-bdf8-449faba34a2f" />

### 6. BONUS — Spray

<img width="798" height="662" alt="Spray" src="https://github.com/user-attachments/assets/3f24486b-3cfd-45d8-b745-86effca695e5" />

## 6. References

- Lecture slides: Midpoint Line, Midpoint Circle, Midpoint Ellipse, and Bézier Curve
- [Midpoint Ellipse Drawing Algorithm — GeeksforGeeks](https://www.geeksforgeeks.org/midpoint-ellipse-drawing-algorithm/)
- [Bézier Curves — JavaScript.info](https://javascript.info/bezier-curve)
