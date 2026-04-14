module fourBitAdder(input [3:0] in, output reg [1:0] out);

    always @(*) begin
        if(in <= 2) begin
            out <= 2'b00;
        end else begin
            out <= {in[3:2] + in[1:0]};
        end
    end

endmodule