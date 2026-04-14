module top_module(
    output reg  md1,
    output reg  md2,
    output reg  md3,
    output reg  md4,
    input   infL,
    input   infR,
    input   clk,
    input   reset_n
);parameter FWD   = 2'b00;
parameter STOP  = 2'b01;
parameter RIGHT = 2'b10;
parameter LEFT  = 2'b11;
parameter HIGH  = 1'b1;
parameter LOW   = 1'b0;


always @(*) begin
    if (infL == LOW && infR == LOW) begin
        
        md1 = HIGH;
        md2 = LOW;
        md3 = HIGH;
        md4 = LOW;
    end else if (infL == HIGH && infR == LOW) begin
        
        md1 = LOW;
        md2 = LOW;
        md3 = HIGH;
        md4 = LOW;
    end else if (infL == LOW && infR == HIGH) begin
        
        md1 = HIGH;
        md2 = LOW;
        md3 = LOW;
        md4 = LOW;
    end else begin
        
        md1 = LOW;
        md2 = LOW;
        md3 = LOW;
        md4 = LOW;
    end
end

endmodule