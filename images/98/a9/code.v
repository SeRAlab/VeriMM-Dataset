module top_module(
    input [7:0] input_data,
    input [15:0] key,
    input enable,
    output reg [7:0] output_data
);reg [7:0] result_A;
reg [7:0] result_B;

always @(*) begin
    if(enable) begin
        result_A = input_data[3:0] * key[7:0];
        result_B = input_data[7:4] * key[15:8];
        output_data = result_A + result_B;
    end else begin
        output_data = input_data;
    end
end

endmodule