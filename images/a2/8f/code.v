module top_module(
    input CLK,
    input RST_N,
    input signed [7:0] A,
    input signed [7:0] B,
    input [2:0] OP,
    output reg RDY,
    output reg signed [7:0] RESULT
);reg signed [7:0] temp_result;

always @(posedge CLK, negedge RST_N) begin
    if (~RST_N) begin
        // Asynchronous reset
        RDY <= 0;
        RESULT <= 0;
    end else begin
        // Perform operation
        case (OP)
            3'b000: temp_result <= A + B;
            3'b001: temp_result <= A - B;
            3'b010: temp_result <= A * B;
            3'b011: temp_result <= A / B;
            3'b100: temp_result <= A % B;
        endcase
        
        // Saturate result if overflow or underflow occurs
        if (temp_result > 127) begin
            RESULT <= 127;
        end else if (temp_result < -128) begin
            RESULT <= -128;
        end else begin
            RESULT <= temp_result;
        end
        
        // Set RDY output
        RDY <= 1;
    end
end

endmodule