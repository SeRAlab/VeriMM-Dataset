module top_module(
    input clk,
    input clkx2,
    input jrst_n,
    input [35:0] tw,
    output reg tr_clk,
    output reg [17:0] tr_data
);reg [1:0] phase;
    reg x1, x2;

    always @(posedge clk or negedge jrst_n) begin
        if (!jrst_n) begin
            x1 <= 1'b0;
        end else begin
            x1 <= ~x1;
        end
    end

    always @(posedge clkx2 or negedge jrst_n) begin
        if (!jrst_n) begin
            x2 <= 1'b0;
            tr_clk <= 1'b0;
            tr_data <= 18'h0;
        end else begin
            x2 <= x1;
            phase <= {x2, x1};
            tr_clk <= ~phase[0];
            tr_data <= phase[1] ? tw[17:0] : tw[35:18];
        end
    end

endmodule