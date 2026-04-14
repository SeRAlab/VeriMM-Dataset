module top_module(
    input [31:0] data1,
    input [31:0] data2,
    input [2:0] ctrl,
    input clk,
    output reg oCarry,
    output reg oZero,
    output reg [31:0] out
);wire [31:0] add_out;
wire [31:0] sub_out;
wire [31:0] and_out;
wire [31:0] xor_out;
wire [31:0] or_out;

assign add_out = data1 + data2;
assign sub_out = data1 - data2;
assign and_out = data1 & data2;
assign xor_out = data1 ^ data2;
assign or_out = data1 | data2;

always @(posedge clk) begin
    case(ctrl)
        3'b000: begin // addition
            out <= add_out;
            oCarry <= (add_out[31] & data2[31]) | (data2[31] & ~out[31]) | (~out[31] & add_out[31]);
            oZero <= (out == 0);
        end
        3'b001: begin // subtraction
            out <= sub_out;
            oCarry <= (~data1[31] & data2[31]) | (data2[31] & out[31]) | (out[31] & ~data1[31]);
            oZero <= (out == 0);
        end
        3'b010: begin // bitwise AND
            out <= and_out;
            oCarry <= 1'b0;
            oZero <= (out == 0);
        end
        3'b011: begin // bitwise XOR
            out <= xor_out;
            oCarry <= 1'b0;
            oZero <= (out == 0);
        end
        3'b100: begin // bitwise OR
            out <= or_out;
            oCarry <= 1'b0;
            oZero <= (out == 0);
        end
        default: begin // invalid control signal
            out <= 32'b0;
            oCarry <= 1'b0;
            oZero <= 1'b0;
        end
    endcase
end

endmodule