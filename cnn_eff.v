`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HackRush 2024
// Engineer: JaidevSK
// 
// Create Date: 13.04.2024 12:08:36
// Design Name: 
// Module Name: cnn
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module cnn(clk, imgadd, final_result);  
    input clk;
    input [3:0] imgadd;
    output reg[3:0] final_result;
   
    reg [7:0] image_input [31:0][31:0][2:0];

    integer image_file; // File handler

// Taking the Input of the Images

    initial begin    
    case (imgadd)
        1: begin
        image_file = $fopen("/Small/1.txt", "r"); // Open the text file
        if (image_file == 0) begin
            $display("Error opening image.txt");
            $finish;
        end
        else
            $fscanf(image_file, "%d\n", image_input); // Read weight in hexadecimal format
            end
        2: begin
        image_file = $fopen("/Small/1.txt", "r"); // Open the text file
        if (image_file == 0) begin
            $display("Error opening image.txt");
            $finish;
        end
        else
            $fscanf(image_file, "%d\n", image_input); // Read weight in hexadecimal format
            end
        endcase
   end   
   
// First Convolution Layer 
    // Loop over image pixels
    reg  [7:0] res1 [0:31][0:31];
    integer i, j;
    always@(*)
    for (i=0; i<32; i=i+1) begin
        for (j=0; j<32; j=j+1) begin
            res1[i][j] = (image_input[i][j][0]+image_input[i][j][1]+image_input[i][j][2])/3;
    end
    end
    
    wire [7:0] conv1 [0:2][0:2];
    wire [7:0] conv1_bias;
   
    assign conv1[0][0] = 0;
    assign conv1[0][1] = 0;
    assign conv1[0][2] = 0;
    assign conv1[1][0] = 0;
    assign conv1[1][1] = 0;
    assign conv1[1][2] = 0;
    assign conv1[2][0] = 0;
    assign conv1[2][1] = 0;
    assign conv1[2][2] = 0;
    assign conv1_bias = 3;
    
    reg  [7:0] res2 [0:29][0:29];

    always@* begin
    for (i = 0; i < 30; i = i + 1) begin
        for (j = 0; j < 30; j = j + 1) begin
            // Apply convolution
            res2[i][j] = (res1[i][j] * conv1[0][0]) +
                           (res1[i][j+1] * conv1[0][1]) +
                           (res1[i][j+2] * conv1[0][2]) +
                           (res1[i+1][j] * conv1[1][0]) +
                           (res1[i+1][j+1] * conv1[1][1]) +
                           (res1[i+1][j+2] * conv1[1][2]) +
                           (res1[i+2][j] * conv1[2][0]) +
                           (res1[i+2][j+1] * conv1[2][1]) +
                           (res1[i+2][j+2] * conv1[2][2]);
        end
    end
    end
    
// Pooling Layer
    
    reg  [7:0] res3 [0:14][0:14];
    reg [7:0] v23, m, v12;

    always@* begin
    for (i = 0; i < 15; i = i + 1) begin
        for (j = 0; j < 15; j = j + 1) begin
            // Select maximum value within 2x2 window
                             
            v12 = res2[2*i][2*j]>=res2[2*i][2*j+1] ? res2[2*i][2*j]:res2[2*i][2*j+1];
            v23 = res2[2*i][2*j+1]>=res2[2*i+1][2*j] ? res2[2*i][2*j+1]:res2[2*i+1][2*j];
            m = v12>=v23 ? v12 : v23;
            res3[i][j] = m>=res2[2*i+1][2*j+1]? m : res2[2*i+1][2*j+1];
            
        end
    end
    end
    
// Second Convolution Layer
    
    wire [7:0] conv2_1 [0:2][0:2];
    wire [7:0] conv2_1_bias;
    
    wire [7:0] conv2_2 [0:2][0:2];
    wire [7:0] conv2_2_bias;
   
    assign conv2_1[0][0] = 0;
    assign conv2_1[0][1] = 0;
    assign conv2_1[0][2] = 0;
    assign conv2_1[1][0] = 0;
    assign conv2_1[1][1] = 0;
    assign conv2_1[1][2] = 0;
    assign conv2_1[2][0] = 0;
    assign conv2_1[2][1] = 0;
    assign conv2_1[2][2] = 0;
    assign conv2_1_bias = 0;
    
    assign conv2_2[0][0] = 0;
    assign conv2_2[0][1] = 0;
    assign conv2_2[0][2] = 0;
    assign conv2_2[1][0] = 0;
    assign conv2_2[1][1] = 0;
    assign conv2_2[1][2] = 0;
    assign conv2_2[2][0] = 0;
    assign conv2_2[2][1] = 0;
    assign conv2_2[2][2] = 0;
    assign conv2_2_bias = 0;
    
    reg  [7:0] res4_1 [0:12][0:12];
    reg  [7:0] res4_2 [0:12][0:12];


    always@* begin
    for (i = 0; i < 13; i = i + 1) begin
        for (j = 0; j < 13; j = j + 1) begin
            // Apply convolution
            res4_1[i][j] = (res3[i][j] * conv2_1[0][0]) +
                           (res3[i][j+1] * conv2_1[0][1]) +
                           (res3[i][j+2] * conv2_1[0][2]) +
                           (res3[i+1][j] * conv2_1[1][0]) +
                           (res3[i+1][j+1] * conv2_1[1][1]) +
                           (res3[i+1][j+2] * conv2_1[1][2]) +
                           (res3[i+2][j] * conv2_1[2][0]) +
                           (res3[i+2][j+1] * conv2_1[2][1]) +
                           (res3[i+2][j+2] * conv2_1[2][2]);
        end
    end
    end
    
    always@* begin
    for (i = 0; i < 13; i = i + 1) begin
        for (j = 0; j < 13; j = j + 1) begin
            // Apply convolution
            res4_2[i][j] = (res3[i][j] * conv2_2[0][0]) +
                           (res3[i][j+1] * conv2_2[0][1]) +
                           (res3[i][j+2] * conv2_2[0][2]) +
                           (res3[i+1][j] * conv2_2[1][0]) +
                           (res3[i+1][j+1] * conv2_2[1][1]) +
                           (res3[i+1][j+2] * conv2_2[1][2]) +
                           (res3[i+2][j] * conv2_2[2][0]) +
                           (res3[i+2][j+1] * conv2_2[2][1]) +
                           (res3[i+2][j+2] * conv2_2[2][2]);
        end
    end
    end
    
// Pooling Layer
    
    reg  [7:0] res5_1 [0:6][0:6];
    reg  [7:0] res5_2 [0:6][0:6];
    
    always@* begin
    for (i = 0; i < 15; i = i + 1) begin
        for (j = 0; j < 15; j = j + 1) begin
            // Select maximum value within 2x2 window
                             
            
            v12 = res4_1[2*i][2*j]>=res4_1[2*i][2*j+1] ? res4_1[2*i][2*j]:res4_1[2*i][2*j+1];
            v23 = res4_1[2*i][2*j+1]>=res4_1[2*i+1][2*j] ? res4_1[2*i][2*j+1]:res4_1[2*i+1][2*j];
            m = v12>=v23 ? v12 : v23;
            res5_1[i][j] = m>=res4_1[2*i+1][2*j+1]? m : res4_1[2*i+1][2*j+1];
            
            v12 = res4_2[2*i][2*j]>=res4_2[2*i][2*j+1] ? res4_2[2*i][2*j]:res4_2[2*i][2*j+1];
            v23 = res4_2[2*i][2*j+1]>=res4_2[2*i+1][2*j] ? res4_2[2*i][2*j+1]:res4_2[2*i+1][2*j];
            m = v12>=v23 ? v12 : v23;
            res5_2[i][j] = m>=res4_2[2*i+1][2*j+1]? m : res4_2[2*i+1][2*j+1];
        end
    end
    end
    
// Third Convolution Layer
    
    wire [7:0] conv6_1 [0:2][0:2];
    wire [7:0] conv6_1_bias;
    
    wire [7:0] conv6_2 [0:2][0:2];
    wire [7:0] conv6_2_bias;
    
    wire [7:0] conv6_3 [0:2][0:2];
    wire [7:0] conv6_3_bias;
    
    wire [7:0] conv6_4 [0:2][0:2];
    wire [7:0] conv6_4_bias;
   
    assign conv6_3[0][0] = 0;
    assign conv6_3[0][1] = 0;
    assign conv6_3[0][2] = 0;
    assign conv6_3[1][0] = 0;
    assign conv6_3[1][1] = 0;
    assign conv6_3[1][2] = 0;
    assign conv6_3[2][0] = 0;
    assign conv6_3[2][1] = 0;
    assign conv6_3[2][2] = 0;
    assign conv6_3_bias = 0;
    
    assign conv6_4[0][0] = 0;
    assign conv6_4[0][1] = 0;
    assign conv6_4[0][2] = 0;
    assign conv6_4[1][0] = 0;
    assign conv6_4[1][1] = 0;
    assign conv6_4[1][2] = 0;
    assign conv6_4[2][0] = 0;
    assign conv6_4[2][1] = 0;
    assign conv6_4[2][2] = 0;
    assign conv6_4_bias = 0;
    
    reg  [7:0] res6_1 [0:3][0:3];
    reg  [7:0] res6_2 [0:3][0:3];
    reg  [7:0] res6_3 [0:3][0:3];
    reg  [7:0] res6_4 [0:3][0:3];


    always@* begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            // Apply convolution
            res6_1[i][j] = (res5_1[i][j] * conv6_1[0][0]) +
                           (res5_1[i][j+1] * conv6_1[0][1]) +
                           (res5_1[i][j+2] * conv6_1[0][2]) +
                           (res5_1[i+1][j] * conv6_1[1][0]) +
                           (res5_1[i+1][j+1] * conv6_1[1][1]) +
                           (res5_1[i+1][j+2] * conv6_1[1][2]) +
                           (res5_1[i+2][j] * conv6_1[2][0]) +
                           (res5_1[i+2][j+1] * conv6_1[2][1]) +
                           (res5_1[i+2][j+2] * conv6_1[2][2]);
        end
    end
    end
    
    
    always@* begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            // Apply convolution
            res6_2[i][j] = (res5_2[i][j] * conv6_1[0][0]) +
                           (res5_2[i][j+1] * conv6_1[0][1]) +
                           (res5_2[i][j+2] * conv6_1[0][2]) +
                           (res5_2[i+1][j] * conv6_1[1][0]) +
                           (res5_2[i+1][j+1] * conv6_1[1][1]) +
                           (res5_2[i+1][j+2] * conv6_1[1][2]) +
                           (res5_2[i+2][j] * conv6_1[2][0]) +
                           (res5_2[i+2][j+1] * conv6_1[2][1]) +
                           (res5_2[i+2][j+2] * conv6_1[2][2]);
        end
    end
    end
    
    
    always@* begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            // Apply convolution
            res6_3[i][j] = (res5_1[i][j] * conv6_2[0][0]) +
                           (res5_1[i][j+1] * conv6_2[0][1]) +
                           (res5_1[i][j+2] * conv6_2[0][2]) +
                           (res5_1[i+1][j] * conv6_2[1][0]) +
                           (res5_1[i+1][j+1] * conv6_2[1][1]) +
                           (res5_1[i+1][j+2] * conv6_2[1][2]) +
                           (res5_1[i+2][j] * conv6_2[2][0]) +
                           (res5_1[i+2][j+1] * conv6_2[2][1]) +
                           (res5_1[i+2][j+2] * conv6_2[2][2]);
        end
    end
    end
    
    
    always@* begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            // Apply convolution
            res6_4[i][j] = (res5_2[i][j] * conv6_2[0][0]) +
                           (res5_2[i][j+1] * conv6_2[0][1]) +
                           (res5_2[i][j+2] * conv6_2[0][2]) +
                           (res5_2[i+1][j] * conv6_2[1][0]) +
                           (res5_2[i+1][j+1] * conv6_2[1][1]) +
                           (res5_2[i+1][j+2] * conv6_2[1][2]) +
                           (res5_2[i+2][j] * conv6_2[2][0]) +
                           (res5_2[i+2][j+1] * conv6_2[2][1]) +
                           (res5_2[i+2][j+2] * conv6_2[2][2]);
        end
    end
    end
    
// Flattening the Layers    
    reg [7:0]flatten1 [63:0];
    
    always@*begin
    for (i = 0; i<6; i=i+1)begin
        for (j = 0; j<6; j=j+1)begin
            flatten1[4*(i*4+j)] = res6_1[i][j];
            flatten1[4*(i*4+j)+1] = res6_2[i][j];
            flatten1[4*(i*4+j)+2] = res6_3[i][j];
            flatten1[4*(i*4+j)+3] = res6_4[i][j];
        end
    end
    end
    
initial begin
  // Open the file for writing.
  integer file = $fopen("output.txt", "w");

  // Write some data to the file.
  $fwrite(file, flatten1);

  // Close the file.
  $fclose(file);
end
  
endmodule
