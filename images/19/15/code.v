module ARQ_System (  
    input wire clk,  
    input wire rst,  
    input wire [4:0] data_in,  
    input wire ack,  
    output reg [4:0] data_out,  
    output reg error_detected,  
    output reg ack_out  
);  
    reg [4:0] sent_data;  
    reg [4:0] received_data;  
    reg parity_bit;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sent_data <= 5'b0;  
            data_out <= 5'b0;  
            error_detected <= 1'b0;  
            ack_out <= 1'b0;  
        end else begin  
            sent_data <= data_in;  
            parity_bit <= ^data_in;  // Calculate parity bit  
            // Assume received_data with error simulation  
            received_data <= sent_data; // This is where you'd get your received data  
            if (ack) begin  
                if (parity_bit !== ^received_data) begin  
                    error_detected <= 1'b1;  
                    ack_out <= 1'b0; // NACK  
                end else begin  
                    error_detected <= 1'b0;  
                    ack_out <= 1'b1; // ACK  
                    data_out <= data_in;  
                end  
            end else if (error_detected) begin  
                data_out <= sent_data; // Retransmit data on NACK  
            end  
        end  
    end  
endmodule