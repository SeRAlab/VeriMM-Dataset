module shift_register_8bit
(
    input clk,
    input rst,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'd0;
    end
    else if (load) begin
        q <= data_in;
    end
    else if (shift) begin
        q <= {1'b0, q[7:1]};
    end
end

endmodule