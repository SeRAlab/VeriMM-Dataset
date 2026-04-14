module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input enable, // clock enable input to choose between register and counter
    input [7:0] d, // 8-bit input for the register
    output [7:0] q, // 8-bit output from the active module
    output [11:0] out_final // 12-bit output from the functional module
);reg [7:0] reg_value;
reg [3:0] counter_value;

always @(posedge clk) begin
    if (reset) begin
        reg_value <= 8'h34;
        counter_value <= 4'b0;
    end else begin
        if (enable) begin
            counter_value <= counter_value + 1;
        end else begin
            reg_value <= d;
        end
    end
end

assign q = enable ? counter_value : reg_value;
assign out_final = {reg_value, counter_value};

endmodule