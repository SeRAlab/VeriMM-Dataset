module top_module(clk, rst, height, ram_address, ram_data, mode, on_off);input clk, rst, mode, on_off; 
    input [8:0] ram_address; 
    output reg [47:0] ram_data; 
    reg [23:0] top, bottom; 
    input [3:0] height; 
    reg [4:0] inner_height; 
    reg [23:0] color; 
    reg addsub; 

    initial begin 
        top <= 0; 
        bottom <= 0; 
        ram_data <= 0; 
        inner_height <= 0; 
        color <= 0; 
        addsub <= 0; 
    end 

    always @ (posedge clk) begin 
        if (mode == 1'b1) begin 
            if (ram_address == 0) begin 
                color <= color + 1'b1; 
                inner_height <= height;  // Fixed the concatenation error
            end 
            bottom <= 24'b0;  // Changed from {24{1'b0}} to 24'b0
            top <= 24'b0;     // Changed from {24{1'b0}} to 24'b0
            
            if (ram_address > 512 - 1 - $unsigned(inner_height) * 32) begin 
                top <= color; 
            end 
            if (ram_address < $unsigned(inner_height) * 32) begin 
                bottom <= color; 
            end 
            ram_data <= {bottom, top}; 
        end 
        else begin 
            if (on_off == 1'b1) begin 
                ram_data <= {8'd179, 8'd255, 8'd255, 8'd179, 8'd255, 8'd255}; 
            end 
            else begin 
                ram_data <= 48'b0; 
            end 
        end 
    end 
endmodule