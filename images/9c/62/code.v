module top_module(
    input clk,
    input A,
    input B,
    input Load,
    input Reset,
    output reg [2:0] Q
);reg [2:0] Q_next;

    always @(posedge clk) begin
        if (Reset) begin
            Q <= 3'b0;
        end
        else begin
            Q <= Q_next;
        end
    end

    always @(*) begin
        if (Load) begin
            Q_next = {A, B, Q[1]};
        end
        else begin
            Q_next = {Q[1:0], A};
        end
    end

endmodule