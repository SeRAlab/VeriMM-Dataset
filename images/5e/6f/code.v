module top_module(
    input [3:0] in,
    output reg [1:0] pos,
    output reg [3:0] gray
);wire [3:0] in_or;
    wire [3:0] in_xor;
    wire [3:0] in_and;

    assign in_or = in[0] | in[1] | in[2] | in[3];
    assign in_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
    assign in_and = in[0] & in[1] & in[2] & in[3];

    always @* begin
        if (in_or == 0) begin
            pos = 2'b00;
            gray = 4'b0000;
        end else if (in_and == 1) begin
            pos = 2'b11;
            gray = 4'b1111;
        end else begin
            case (in_xor)
                4'b0001: begin
                    pos = 2'b01;
                    gray = 4'b0001;
                end
                4'b0010: begin
                    pos = 2'b10;
                    gray = 4'b0011;
                end
                4'b0100: begin
                    pos = 2'b10;
                    gray = 4'b0110;
                end
                4'b1000: begin
                    pos = 2'b10;
                    gray = 4'b1100;
                end
            endcase
        end
    end

endmodule