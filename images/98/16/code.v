module top_module(input CLK, input [1:0] CONTROL, input CLEAR, input [7:0] A, input [7:0] B, output reg [7:0] C);reg [7:0] temp;

always @(posedge CLK) begin
    if (CLEAR) begin
        C <= 0;
        temp <= 0;
    end else begin
        case (CONTROL)
            2'b00: begin // addition
                temp <= A + B;
                C <= temp;
            end
            2'b01: begin // subtraction
                temp <= A - B;
                C <= temp;
            end
            2'b10: begin // multiplication
                temp <= A * B;
                C <= temp;
            end
            2'b11: begin // division
                temp <= A / B;
                C <= temp;
            end
            default: begin
                C <= 0;
                temp <= 0;
            end
        endcase
    end
end

endmodule