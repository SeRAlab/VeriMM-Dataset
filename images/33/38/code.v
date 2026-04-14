module shift_register_2bit (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            q <= 2'b00;  
        end else begin  
            q <= {q[0], serial_in};  
        end  
    end  
endmodule