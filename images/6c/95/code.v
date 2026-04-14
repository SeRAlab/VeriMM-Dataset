module top_module(
    input clk,           // Added clk input
    input reset,        // Added reset input
    input [7:0] in,
    output reg [8:0] out // Changed output to reg, to hold value in always block
);reg [2:0] stage;
reg [7:0] input_reg;
reg [8:0] output_reg;

always @(*) begin
    case(stage)
        0: input_reg = in;
        1: begin
            output_reg[8] = ~(input_reg[7] ^ input_reg[6] ^ input_reg[5] ^ input_reg[4] ^ input_reg[3] ^ input_reg[2] ^ input_reg[1] ^ input_reg[0]);
            output_reg[7:0] = input_reg;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        stage <= 0;
        output_reg <= 0;
    end else begin
        case(stage)
            0: stage <= 1;
            1: stage <= 0;
        endcase
        out <= output_reg; // Updated to assign output_reg to out on clock edge
    end
end

endmodule