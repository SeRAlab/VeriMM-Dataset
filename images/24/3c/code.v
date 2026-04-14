module gpio_controller(  
    input wire clk,  
    input wire control, // control signal: 1 for write, 0 for read  
    input wire [7:0] data_in, // data input for writing  
    output reg [7:0] data_out // data output for reading  
);  
    reg [7:0] data_reg; // 8-bit data register  

    always @(posedge clk) begin  
        if (control) begin  
            // Write operation  
            data_reg <= data_in;  
        end else begin  
            // Read operation  
            data_out <= data_reg;  
        end  
    end  
endmodule