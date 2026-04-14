module top_module(
    input signed [7:0] A,
    input signed [7:0] B,
    input RST,
    output reg signed [7:0] S,
    output reg OV, // overflow flag
    output reg UV // underflow flag
    );always @(A, B, RST) begin
        if (RST) begin
            S <= 0;
            OV <= 0;
            UV <= 0;
        end else begin
            S <= A + B;
            if ((A > 0 && B > 0 && S < 0) || (A < 0 && B < 0 && S > 0)) begin
                OV <= 1;
            end else begin
                OV <= 0;
            end
            
            if ((A < 0 && B > 0 && S > 0) || (A > 0 && B < 0 && S < 0)) begin
                UV <= 1;
            end else begin
                UV <= 0;
            end
        end
    end

endmodule