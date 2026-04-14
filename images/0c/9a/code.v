module ARQ (
    input clk,
    input rst,
    input [4:0] data_in,
    input error_detected,
    output reg [4:0] data_out,
    output reg ack
);
    reg [4:0] last_valid_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'b00000;
            last_valid_data <= 5'b00000;
            ack <= 0;
        end else begin
            if (error_detected) begin
                data_out <= last_valid_data; // resend last valid data
                ack <= 0; // no acknowledgment since there was an error
            end else begin
                last_valid_data <= data_in; // store current data as valid
                data_out <= data_in; // send current data
                ack <= 1; // acknowledge reception
            end
        end
    end
endmodule