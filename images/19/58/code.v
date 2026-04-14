module shift_register(  
    input clk,  
    input load,  
    input shift_dir,  
    input [15:0] data_in,  
    output reg [15:0] q  
);  
    always @(posedge clk) begin  
        if (load)  
            q <= data_in;  
        else if (shift_dir)  
            q <= {q[14:0], 1'b0}; // Shift left  
        else  
            q <= {1'b0, q[15:1]}; // Shift right  
    end  
endmodule