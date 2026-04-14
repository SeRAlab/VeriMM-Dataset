module dma_controller(  
    input wire clk,  
    input wire start,  
    input wire [1:0] channel_select,  
    input wire [7:0] data_in0,  
    input wire [7:0] data_in1,  
    input wire [7:0] data_in2,  
    input wire [7:0] data_in3,  
    output reg [7:0] data_out  
);  
    always @(posedge clk) begin  
        if (start) begin  
            case (channel_select)  
                2'b00: data_out <= data_in0;  
                2'b01: data_out <= data_in1;  
                2'b10: data_out <= data_in2;  
                2'b11: data_out <= data_in3;  
                default: data_out <= 8'b00000000;  
            endcase  
        end  
    end  
endmodule