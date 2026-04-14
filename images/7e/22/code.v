module top_module(
    input clk,
    input up_down,
    input load,
    input [3:0] input_data,
    output reg [3:0] Q
);reg [3:0] Q_reg1, Q_reg2;

always @(posedge clk) begin
    Q_reg1 <= Q;
end

always @(posedge clk) begin
    Q_reg2 <= Q_reg1;
end

always @(posedge clk) begin
    if (load) begin
        Q_reg1 <= input_data;
    end else begin
        if (up_down) begin
            Q_reg1 <= Q_reg2 + 1;
        end else begin
            Q_reg1 <= Q_reg2 - 1;
        end
    end
end

assign Q = Q_reg2;

endmodule