module adc_interface (
    input [23:0] data_in,
    output reg [3:0] data_out
);
    always @(*) begin
        if (data_in < 24'h00FFFFF / 16) begin
            data_out = 4'b0000; // Output 0
        end else if (data_in < 24'h00FFFFF / 8) begin
            data_out = 4'b0001; // Output 1
        end else if (data_in < 24'h00FFFFF * 3 / 16) begin
            data_out = 4'b0010; // Output 2
        end else if (data_in < 24'h00FFFFF / 4) begin
            data_out = 4'b0011; // Output 3
        end else begin
            data_out = 4'b0100; // Output 4
        end
    end
endmodule