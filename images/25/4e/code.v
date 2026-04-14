module arq_system (
    input clk,
    input rst,
    input [4:0] data_in,
    input data_valid,
    output reg [4:0] received_data,
    output reg resend,
    output reg parity_error
);
    reg [4:0] sent_data;
    reg parity_bit;

    // Function to calculate parity
    function parity;
        input [4:0] data;
        integer i;
        begin
            parity = 0;
            for (i = 0; i < 5; i = i + 1) begin
                parity = parity ^ data[i];
            end
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_data <= 0;
            received_data <= 0;
            resend <= 0;
            parity_error <= 0;
        end else if (data_valid) begin
            sent_data <= data_in;
            parity_bit <= parity(data_in);
            // Simulating transmission and reception with potential error
            if (sent_data[0] ^ parity_bit) begin
                parity_error <= 1; // Simulate an error
                resend <= 1; // Request resend
            end else begin
                received_data <= sent_data; // Correct data received
                resend <= 0;
                parity_error <= 0;
            end
        end
    end
endmodule