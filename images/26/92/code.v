module ARQ_System(
    input clk,
    input reset,
    input [4:0] data_in, // 5-bit data input
    input error_detected, // signal indicating an error
    output reg [4:0] data_out, // data output to the receiver
    output reg request_resend // signal to request a resend
);
    reg [2:0] packet_count; // count packets sent

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            packet_count <= 3'b000;
            data_out <= 5'b00000;
            request_resend <= 1'b0;
        end else begin
            if (packet_count < 3'b101) begin // limit to 5 packets
                data_out <= data_in; // send data
                if (error_detected) begin
                    request_resend <= 1'b1; // request resend if error is detected
                end else begin
                    request_resend <= 1'b0; // no error, do not request resend
                    packet_count <= packet_count + 1; // increment packet count
                end
            end
        end
    end
endmodule