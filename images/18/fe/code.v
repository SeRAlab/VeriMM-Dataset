module SRAM_Cell(  
    input [7:0] data_in,  
    input we,  // Write Enable  
    input re,  // Read Enable  
    input reset,  
    output reg [7:0] data_out  
);  
    always @(posedge reset or posedge we or posedge re) begin  
        if (reset) begin  
            data_out <= 8'b0;  
        end else if (we) begin  
            data_out <= data_in;  
        end else if (re) begin  
            data_out <= data_out;  
        end  
    end  
endmodule