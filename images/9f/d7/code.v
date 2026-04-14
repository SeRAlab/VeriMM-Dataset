module top_module(clk, rst, load, A, B, Q);input clk, rst, load;
input [3:0] A, B;
output [3:0] Q;

reg [3:0] Q_reg;
wire [3:0] sum;

assign sum = A + B;

always @(posedge clk) begin
    if (rst) begin
        Q_reg <= 4'b0;
    end else begin
        if (load) begin
            Q_reg <= sum;
        end
    end
end

assign Q = Q_reg;

endmodule