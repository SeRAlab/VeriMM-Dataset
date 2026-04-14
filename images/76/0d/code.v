module shift_reg_8bit(
    input wire clk,
    input wire rst,
    input wire [1:0] ctrl,
    input wire [7:0] parallel_in,
    output reg [7:0] q
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'b0;
    end else begin
        case (ctrl)
            2'b00: q <= q; // hold
            2'b01: q <= {q[6:0], 1'b0}; // shift left
            2'b10: q <= {1'b0, q[7:1]}; // shift right
            2'b11: q <= parallel_in; // load parallel
            default: q <= q;
        endcase
    end
end

endmodule