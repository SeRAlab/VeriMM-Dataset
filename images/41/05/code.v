module gpio_controller(  
    input wire clk,  
    input wire reset,  
    input wire control,  // 0 for read, 1 for write  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] data_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_reg <= 8'b0;  
            data_out <= 8'b0;  
        end else begin  
            if (control) begin  
                // Write mode  
                data_reg <= data_in;  
            end else begin  
                // Read mode  
                data_out <= data_reg;  
            end  
        end  
    end  
endmodule