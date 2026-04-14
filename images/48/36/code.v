module shift_register(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b00000000;
        end else if (load) begin
            q <= data;
        end else begin
            q <= {1'b0, q[7:1]};
        end
    end
endmodule