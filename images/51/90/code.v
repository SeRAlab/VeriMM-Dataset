module top_module(
    input clock,
    input reset_n,
    input [2:0] a_in,
    input [1:0] b_in,
    output reg [3:0] out0,
    output reg out1,
    output reg out5,
    output reg [3:0] out6,
    output reg out7,
    output reg [3:0] out8
    );always @(posedge clock) begin
        case(a_in)
            3'b000: out0 <= 4'b1111;
            3'b001: out0 <= 4'b1110;
            3'b010: out0 <= 4'b1101;
            3'b011: out0 <= 4'b1100;
            3'b100: out0 <= 4'b1011;
            3'b101: out0 <= 4'b1010;
            3'b110: out0 <= 4'b1001;
            3'b111: out0 <= 4'b1000;
            default: out0 <= 4'b0000;
        endcase
    end
    
    always @(posedge clock) begin
        case(b_in)
            2'b00: out1 <= 1'b1;
            default: out1 <= 1'b0;
        endcase
    end
    
    always @(posedge clock) begin
        if(b_in == 2'b00) begin
            out5 <= 1'b1;
            out6 <= 4'b0001;
        end else begin
            out5 <= 1'b0;
            out6 <= 4'b0000;
        end
    end
    
    always @(posedge clock) begin
        case(a_in)
            1'b0, 3'bxxx: out7 <= 1'b1;
            3'b000: out7 <= 1'b0;
            default: out7 <= 1'b1;
        endcase
        
        case(a_in)
            1'b0: out8 <= 4'b0001;
            3'b000: out8 <= 4'b0100;
            default: out8 <= 4'b0000;
        endcase
    end
    
endmodule