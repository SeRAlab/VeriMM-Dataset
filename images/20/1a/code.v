module SRAM16bit (
    input wire [15:0] data_in,
    input wire we,
    output reg [15:0] data_out
);
    always @(posedge we) begin
        if (we) begin
            data_out <= data_in;
        end
    end
endmodule