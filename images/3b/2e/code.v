module arq_system (  
    input clk,  
    input rst,  
    input data_in,  
    input parity_in,  
    output reg ack_out,  
    output reg retransmit  
);  

reg data_reg;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        data_reg <= 0;  
        ack_out <= 0;  
        retransmit <= 0;  
    end else begin  
        data_reg <= data_in;  
        // Check parity  
        if (data_in ^ parity_in) begin  
            ack_out <= 0; // error detected  
            retransmit <= 1; // request retransmission  
        end else begin  
            ack_out <= 1; // no error  
            retransmit <= 0; // no retransmission needed  
        end  
    end  
end  
endmodule