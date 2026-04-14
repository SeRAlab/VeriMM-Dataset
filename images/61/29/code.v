module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input [1:0] Sel,
    input clk,
    output reg [3:0] Sum,  // Change output to reg
    output reg Cout,       // Change output to reg
    output reg [3:0] Z     // Change output to reg
    );reg [3:0] temp_sum;
    reg temp_cout;

    always @(posedge clk) begin
        case (Sel)
            2'b00: begin // addition
                temp_sum = A + B + Cin;
                temp_cout = (temp_sum > 4'hF);
                Sum = temp_sum;
                Cout = temp_cout;
                Z = 4'h0; // Move temp_z logic to Z directly
            end
            2'b01: begin // subtraction
                temp_sum = A - B - Cin;
                temp_cout = (temp_sum < 0);
                Sum = temp_sum;
                Cout = temp_cout;
                Z = 4'h0; // Move temp_z logic to Z directly
            end
            2'b10: begin // bitwise AND
                Z = A & B;
                Sum = 4'h0;
                Cout = 1'b0;
            end
            2'b11: begin // bitwise OR
                Z = A | B;
                Sum = 4'h0;
                Cout = 1'b0;
            end
            default: begin
                temp_sum = 4'h0;
                temp_cout = 1'b0;
                Z = 4'h0; // Move temp_z logic to Z directly
            end
        endcase
    end

endmodule