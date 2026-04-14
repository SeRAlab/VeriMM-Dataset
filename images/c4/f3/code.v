module mux_4_1_enable(
    input [3:0] MUX_INPUTS,
    input [1:0] MUX_SELECT,
    input EN,
    output [31:0] MUX_OUTPUT
);

    wire [31:0] selected_input;

    assign selected_input = MUX_SELECT[1] ? MUX_INPUTS[3] : MUX_INPUTS[2];

    always @(*) begin
        case (MUX_SELECT)
            2'b00: MUX_OUTPUT = MUX_INPUTS[0];
            2'b01: MUX_OUTPUT = MUX_INPUTS[1];
            2'b10: MUX_OUTPUT = selected_input;
            2'b11: MUX_OUTPUT = MUX_INPUTS[3];
        endcase

        if (!EN) begin
            MUX_OUTPUT = 32'h00000000;
        end
    end
endmodule