module top_module(
    input D,
    input RESET_B,
    input CLK,
    output reg Q,
    output Q_B
);assign Q_B = ~Q;
    
    always @(posedge CLK or negedge RESET_B) begin
        if (~RESET_B) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule