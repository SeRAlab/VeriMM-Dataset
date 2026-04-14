module ethernet_mac_controller(  
    input clk,  
    input rst_n,  
    input valid_frame,  
    input [7:0] data_in,  
    output reg data_ready,  
    output reg [7:0] buffer  
);  

always @(posedge clk or negedge rst_n) begin  
    if (!rst_n) begin  
        data_ready <= 0;  
        buffer <= 8'b0;  
    end else if (valid_frame) begin  
        buffer <= data_in;  
        data_ready <= 1;  
    end else begin  
        data_ready <= 0;  
    end  
end  

endmodule