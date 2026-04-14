module decoder_2to4(
    input [1:0] in,
    input enable,
    output reg [3:0] out
);

    // Always block triggered on changes to the inputs
    always @(*) begin
        if (enable) begin
            case (in)
                2'b00: out = 4'b0001;
                2'b01: out = 4'b0010;
                2'b10: out = 4'b0100;
                2'b11: out = 4'b1000;
                default: out = 4'b0000;
            endcase
        end else begin
            out = 4'b0000;  // Output is zero when enable is low
        end
    end

endmodule