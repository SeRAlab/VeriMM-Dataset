module top_module(
    input clk,
    input [3:0] col,
    output reg [7:0] out
);reg [3:0] row;
    reg [3:0] key_pressed;
    reg [3:0] shifted_key_pressed;
    
    // 4x4 matrix keypad scanner
    always @(posedge clk) begin
        row <= 4'b1110;
        if (col == 4'b1110) key_pressed <= 4'b0001;
        else if (col == 4'b1101) key_pressed <= 4'b0010;
        else if (col == 4'b1011) key_pressed <= 4'b0100;
        else if (col == 4'b0111) key_pressed <= 4'b1000;
        else key_pressed <= 4'b0000;
    end
    
    // 4-bit binary left shift module
    always @(posedge clk) begin
        shifted_key_pressed[3:1] <= key_pressed[2:0];
        shifted_key_pressed[0] <= key_pressed[3];
    end
    
    // Concatenate the output from the keypad scanner and the left shift module
    always @(posedge clk) begin
        out <= {shifted_key_pressed, key_pressed};
    end
    
endmodule