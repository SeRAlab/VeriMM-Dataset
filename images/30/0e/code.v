module ARQ_Controller (  
    input clk,  
    input rst,  
    input data_in,  
    input parity_in,  
    output reg request_resend,  
    output reg [1:0] attempts  
);  
  
    reg parity_check;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            attempts <= 0;  
            request_resend <= 0;  
        end else begin  
            parity_check <= data_in ^ parity_in;  
            if (parity_check) begin  
                if (attempts < 2) begin  
                    attempts <= attempts + 1;  
                    request_resend <= 1;  
                end else begin  
                    attempts <= 2;  
                    request_resend <= 0;  
                end  
            end else begin  
                attempts <= 0;  
                request_resend <= 0;  
            end  
        end  
    end  
endmodule