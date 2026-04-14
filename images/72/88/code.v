module top_module(
    input [3:0] in_a,
    input [3:0] in_b,
    input mode,
    input clk, // Added the clk input declaration
    output reg [3:0] out,
    output reg overflow // Changed to reg since we are assigning it within always blocks
);reg [4:0] temp_out;
    reg mode_inv;
    
    always @(*) begin
        mode_inv = ~mode;
        if (mode == 0) begin
            temp_out = in_a + in_b;
        end else begin
            temp_out = in_a - in_b;
        end
    end
    
    always @(*) begin
        if (temp_out > 7 || temp_out < -8) begin
            overflow = 1;
        end else begin
            overflow = 0;
        end
    end
    
    always @(posedge clk) begin
        out <= temp_out[3:0];
    end
    
endmodule