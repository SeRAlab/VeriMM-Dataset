module shift_register (
    input wire clk,
    input wire rst,
    output reg [1:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 2'b00;
        end else begin
            q <= {1'b0, q[1]};
        end
    end
endmodule