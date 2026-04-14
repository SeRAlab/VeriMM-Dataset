module ARQ_System(  
    input clk,  
    input reset,  
    input [4:0] data_in,  
    input parity_in,  
    input error_signal,  
    output reg [4:0] data_out,  
    output reg ack_signal  
);  
    reg [4:0] last_transmitted_data;  
    reg error_detected;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 5'b00000;  
            ack_signal <= 0;  
            last_transmitted_data <= 5'b00000;  
            error_detected <= 0;  
        end else begin  
            if (error_signal) begin  
                data_out <= last_transmitted_data;  
                error_detected <= 1;  
                ack_signal <= 0;  
            end else begin  
                if (parity_in == ^data_in) begin  
                    data_out <= data_in;  
                    last_transmitted_data <= data_in;  
                    ack_signal <= 1;  
                    error_detected <= 0;  
                end else begin  
                    data_out <= last_transmitted_data;  
                    ack_signal <= 0;  
                end  
            end  
        end  
    end  
endmodule