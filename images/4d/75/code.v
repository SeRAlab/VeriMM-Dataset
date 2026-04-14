module top_module(
    input clk,
    input reset,      // Active-high synchronous reset
    input load,       // Asynchronous active-high load input
    input [7:0] load_value, // 8-bit load value
    input [1:0] ena, // Left/right enable inputs for the barrel shifter
    input [7:0] data, // Input for the barrel shifter
    output reg [7:0] counter_out, // 8-bit output from the counter
    output reg [7:0] shifter_out, // 8-bit output from the barrel shifter
    output reg [7:0] final_out // Sum of counter and barrel shifter outputs
);reg [7:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 8'b0;
    end else if (load) begin
        counter <= load_value;
    end else begin
        counter <= counter + 1;
    end
end

always @(*) begin
    case (ena)
        2'b00: shifter_out = data; // No shift
        2'b01: shifter_out = data << 1; // Left shift by 1
        2'b10: shifter_out = data >> 1; // Right shift by 1
        2'b11: shifter_out = data << 2; // Left shift by 2
    endcase
end

always @(posedge clk) begin
    final_out <= counter_out + shifter_out;
end

assign counter_out = counter;

endmodule