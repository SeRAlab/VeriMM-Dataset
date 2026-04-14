module top_module( 
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [11:0] out   
);reg [3:0] mux_out;
    reg [3:0] bitwise_out;
    reg [3:0] and_out;
    reg [3:0] or_out;
    reg [3:0] xor_out;

    always @(*) begin
        case (sel)
            3'b000: mux_out = data0;
            3'b001: mux_out = data1;
            3'b010: mux_out = data2;
            3'b011: mux_out = data3;
            3'b100: mux_out = data4;
            3'b101: mux_out = data5;
            default: mux_out = 4'b0000;
        endcase

        if (sel % 2 == 0) begin
            and_out = mux_out & 4'b1111; // This line works fine
            or_out = 4'b1111;            // This line works fine
        end else begin
            and_out = 4'b1111;            // This line works fine
            or_out = mux_out | 4'b1111;   // Fixed the size of the constant
        end

        case (sel)
            3'b000: begin
                xor_out = and_out ^ or_out;
            end
            3'b001: begin
                xor_out = and_out & or_out;
            end
            3'b010: begin
                xor_out = and_out | or_out;
            end
            default: begin
                xor_out = 4'b0000;
            end
        endcase

        bitwise_out = {and_out, or_out, xor_out};
    end

    assign out = bitwise_out;

endmodule