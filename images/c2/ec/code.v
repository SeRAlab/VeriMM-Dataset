module data_processing_module (
    input data_in,
    input [3:0] power_in,
    output reg data_out
);

    always @(*) begin
        if (data_in == 1'b1) begin
            if (power_in == 4'b1010) begin
                data_out <= 1'b1;
            end
            else begin
                data_out <= 1'bx;
            end
        end
        else begin
            if (power_in == 4'b1010) begin
                data_out <= 1'b0;
            end
            else begin
                data_out <= 1'bx;
            end
        end
    end

endmodule