module data_converter (
    input [3:0] data_in,
    output [1:0] data_out
);

    always @* begin
        if (data_in <= 4) begin
            data_out = 2'b00;
        end else if (data_in <= 8) begin
            data_out = 2'b01;
        end else if (data_in <= 12) begin
            data_out = 2'b10;
        end else begin
            data_out = 2'b11;
        end
    end

endmodule