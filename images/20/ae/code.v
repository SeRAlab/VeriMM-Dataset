module dma_controller(  
    input clk,  
    input rst,  
    input req_chan1,  
    input req_chan2,  
    output reg ack_chan1,  
    output reg ack_chan2,  
    output reg [7:0] data  
);  
    reg [7:0] src_data1;  
    reg [7:0] src_data2;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ack_chan1 <= 0;  
            ack_chan2 <= 0;  
            data <= 8'b0;  
        end else begin  
            if (req_chan1) begin  
                ack_chan1 <= 1;  
                data <= src_data1;  
            end else begin  
                ack_chan1 <= 0;  
            end  
            
            if (req_chan2) begin  
                ack_chan2 <= 1;  
                data <= src_data2;  
            end else begin  
                ack_chan2 <= 0;  
            end  
        end  
    end  
endmodule