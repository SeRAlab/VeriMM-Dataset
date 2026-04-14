module ARQ_System(  
    input clk,  
    input reset,  
    input valid,  
    input data_in,  
    output reg ack,  
    output reg data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 0;  
            ack <= 0;  
        end else begin  
            if (valid) begin  
                data_out <= data_in;  
                ack <= 1;  
            end else begin  
                ack <= 0;  
            end  
        end  
    end  
endmodule