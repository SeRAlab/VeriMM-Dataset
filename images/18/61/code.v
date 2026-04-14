module deserializer_16bit(  
    input wire clk,  
    input wire serial_in,  
    output reg [15:0] parallel_out  
);  
    reg [3:0] count;  
    reg [15:0] shift_reg;  

    always @(posedge clk) begin  
        shift_reg <= {shift_reg[14:0], serial_in};  
        if (count == 15) begin  
            parallel_out <= shift_reg;  
            count <= 0;  
        end else begin  
            count <= count + 1;  
        end  
    end  
endmodule