module ARQ_Circuit (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input ack_in,  
    output reg [7:0] data_out,  
    output reg resend  
);  

    reg [7:0] last_sent_data;  
    reg last_ack;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            last_sent_data <= 8'b0;  
            last_ack <= 1'b0;  
            resend <= 1'b0;  
            data_out <= 8'b0;  
        end else begin  
            if (last_ack) begin  
                // If last acknowledgment was good, send new data  
                last_sent_data <= data_in;  
                data_out <= data_in;  
                resend <= 1'b0;  
            end else begin  
                // If last acknowledgment was bad, resend last data  
                data_out <= last_sent_data;  
                resend <= 1'b1;  
            end  
            last_ack <= ack_in;  
        end  
    end  
endmodule