module top_module(
    Q      ,
    CLK    ,
    RESET_B
);output reg [1:0] Q;
    input  CLK;
    input  RESET_B;

    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 2'b00;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule