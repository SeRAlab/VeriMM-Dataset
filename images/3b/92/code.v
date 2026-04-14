module SR_FF (
    input wire clk,
    input wire S,
    input wire R,
    input wire rst_n,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            if (R) begin
                Q <= 0;
                Qn <= 1;
            end else if (S) begin
                Q <= 1;
                Qn <= 0;
            end
        end
    end
endmodule