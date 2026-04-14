module shift_register(  
    input wire clk,  
    input wire reset,  
    input wire shift_dir, // 1 for left, 0 for right  
    input wire shift_in,  // the bit to shift in  
    output reg [7:0] data  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data <= 8'b00000000;  
        end else begin  
            if (shift_dir) begin  
                data <= {data[6:0], shift_in}; // Shift left  
            end else begin  
                data <= {shift_in, data[7:1]}; // Shift right  
            end  
        end  
    end  
endmodule