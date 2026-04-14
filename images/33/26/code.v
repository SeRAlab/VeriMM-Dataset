module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [1:0] channel_select,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg transfer_done  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b0;  
            transfer_done <= 1'b0;  
        end else if (start) begin  
            case (channel_select)  
                2'b00: data_out <= data_in;  
                2'b01: data_out <= data_in + 8'h01;  
                2'b10: data_out <= data_in + 8'h02;  
                2'b11: data_out <= data_in + 8'h03;  
                default: data_out <= 8'b0;  
            endcase  
            transfer_done <= 1'b1;  
        end else begin  
            transfer_done <= 1'b0;  
        end  
    end  
endmodule