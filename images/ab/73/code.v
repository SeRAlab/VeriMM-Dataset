module top_module(
    input clk,
    input ena,
    output reg pulse,
    output reg cycle
);reg [1:0] state;

always @(posedge clk) begin
    cycle <= state[0];
    if (ena) begin
        state <= 2'b01;
        pulse <= 1'b1;
    end
    else begin
        state <= 2'b10;
        pulse <= 1'b0;
    end
end

endmodule