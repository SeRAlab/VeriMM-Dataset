module ARQ (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    input wire ack,
    output reg [3:0] data_out,
    output reg error_detected
);

reg [3:0] transmitted_data;
reg [3:0] received_data;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 4'b0000;
        error_detected <= 0;
        transmitted_data <= 4'b0000;
    end else begin
        transmitted_data <= data_in;
        if (ack) begin
            error_detected <= 0;
            data_out <= transmitted_data;
        end else begin
            error_detected <= 1; // Error detected, resend data
            data_out <= transmitted_data; // Resend the last transmitted data
        end
    end
end

endmodule