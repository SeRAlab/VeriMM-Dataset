module ARQ_Error_Correction(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire [7:0] data_received,  
    input wire parity_received,  
    output reg request_retransmit  
);  
    reg parity_calculated;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            request_retransmit <= 0;  
        end else begin  
            // Calculate parity (even parity for this example)  
            parity_calculated = ^data_in;  
            // Check if received data's parity matches calculated parity  
            if (parity_calculated != parity_received) begin  
                request_retransmit <= 1;  
            end else begin  
                request_retransmit <= 0;  
            end  
        end  
    end  
endmodule