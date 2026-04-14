module highest_two_bits(input [3:0] in, output [1:0] out);

    always @(*) begin
        if(in < 4'b100) begin
            out = 2'b00;
        end else begin
            out = in[3:2];
        end
    end

endmodule