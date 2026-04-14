module serializer(  
    input wire clk,  
    input wire load,  
    input wire [7:0] data_in,  
    output reg serial_out  
);  
    reg [7:0] shift_reg;  
    reg [2:0] bit_count;  

    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= data_in;  
            bit_count <= 3'b111;  // Start from the MSB  
        end else if (bit_count != 3'b000) begin  
            serial_out <= shift_reg[bit_count];  
            bit_count <= bit_count - 1;  
        end  
    end  
endmodule