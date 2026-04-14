module top_module(
    input wire clk,
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [15:0] add_result,
    output reg [15:0] sub_result,
    output reg [15:0] mul_result,
    output reg [15:0] div_result
);reg [15:0] temp_mul_result;
    reg [15:0] temp_div_result;
    
    always @ (posedge clk) begin
        add_result <= A + B;
        sub_result <= A - B;
        temp_mul_result <= A * B;
        temp_div_result <= A / B;
    end
    
    always @ (posedge clk) begin
        mul_result <= temp_mul_result;
        div_result <= temp_div_result;
    end
    
endmodule