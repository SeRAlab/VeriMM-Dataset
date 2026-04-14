module shift_register (
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output reg [7:0] q);
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'b00000000;
    end else if (load) begin
        q <= data_in;
    end else begin
        q <= {1'b0, q[7:1]};
    end
end
endmodule