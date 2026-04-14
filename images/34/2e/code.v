module sd_card_controller(  
    input wire clk,  
    input wire rst,  
    input wire cmd,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] internal_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            internal_reg <= 8'b0;  
            data_out <= 8'b0;  
        end else begin  
            if (cmd == 1'b1) begin  // Write operation  
                internal_reg <= data_in;  
            end else begin  // Read operation  
                data_out <= internal_reg;  
            end  
        end  
    end  
endmodule