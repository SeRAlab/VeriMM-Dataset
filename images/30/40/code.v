module shift_register_2bit (  
    input wire clk,  
    input wire reset,  
    input wire new_bit,  
    output reg [1:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 2'b00;  
        end else begin  
            out <= {out[0], new_bit};  
        end  
    end  
endmodule