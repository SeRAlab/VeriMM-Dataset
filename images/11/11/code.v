module ethernet_mac_controller(  
    input wire clk,  
    input wire rst,  
    input wire [31:0] data_in,  
    input wire valid,  
    output reg ready  
);  

    reg [31:0] data_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_reg <= 32'b0;  
            ready <= 1'b0;  
        end else begin  
            if (valid) begin  
                data_reg <= data_in;  
                ready <= 1'b1;  
            end else begin  
                ready <= 1'b0;  
            end  
        end  
    end  
endmodule