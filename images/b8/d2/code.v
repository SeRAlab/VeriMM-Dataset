module top_module(
    input [7:0] data_in,
    input load,
    input reset,
    input clock,
    output reg [7:0] data_out
);reg [7:0] reg_value;

always @(posedge clock) begin
    if (reset) begin
        reg_value <= 8'b0;
    end else if (load) begin
        reg_value <= data_in;
    end else begin
        reg_value <= reg_value;
    end
end

assign data_out = reg_value;

endmodule