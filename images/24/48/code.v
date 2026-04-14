module gpio_controller(  
    input wire clk,  
    input wire reset,  
    input wire control,  // 0 for write, 1 for read  
    input wire [7:0] data_in,  // data to write  
    output reg [7:0] data_out,  // data read  
    output reg [7:0] pins       // GPIO pins  
);  
    reg [7:0] shift_reg;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 8'b0;  
            data_out <= 8'b0;  
            pins <= 8'b0;  
        end else begin  
            if (control == 0) begin  // Write operation  
                shift_reg <= data_in;  
                pins <= shift_reg;  
            end else begin  // Read operation  
                data_out <= pins;  
            end  
        end  
    end  
endmodule