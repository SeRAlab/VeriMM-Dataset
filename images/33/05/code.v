module checksum (
    input wire [7:0] data,
    input wire checksum_in,
    input wire control,
    input wire reset,
    output reg valid
);
    reg [7:0] computed_checksum;

    always @(posedge reset or posedge control) begin
        if (reset) begin
            computed_checksum <= 8'b0;
            valid <= 0;
        end else if (control) begin
            computed_checksum <= data;
            valid <= (computed_checksum ^ checksum_in) == 0; // Checksum validation
        end else begin
            computed_checksum <= computed_checksum ^ data; // Compute checksum
            valid <= 0; // Valid output not used when computing
        end
    end
endmodule