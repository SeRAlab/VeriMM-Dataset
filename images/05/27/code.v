module ARQ_system(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [7:0] checksum_in,
    output reg request_resend
);
    reg [7:0] calculated_checksum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            calculated_checksum <= 8'b0;
            request_resend <= 1'b0;
        end
        else begin
            calculated_checksum <= data_in; // Simple checksum calculation (for illustration)
            if (calculated_checksum != checksum_in) begin
                request_resend <= 1'b1; // Request resend
            end else begin
                request_resend <= 1'b0; // No resend needed
            end
        end
    end
endmodule