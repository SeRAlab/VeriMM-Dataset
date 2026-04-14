module bluetooth_address_incrementer(  
    input wire clk,  
    input wire enable,  
    output reg [3:0] address  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            address <= (address + 1) & 4'b1111; // Increment address and wrap around  
        end  
    end  
endmodule