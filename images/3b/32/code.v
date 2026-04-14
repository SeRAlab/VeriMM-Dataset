module eth_mac_controller (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input store,  
    input retrieve,  
    output reg [7:0] data_out  
);  
    reg [7:0] data_reg;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_reg <= 8'b0;  
            data_out <= 8'b0;  
        end else begin  
            if (store) begin  
                data_reg <= data_in;  
            end  
            if (retrieve) begin  
                data_out <= data_reg;  
            end  
        end  
    end  
endmodule