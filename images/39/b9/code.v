module conv_encoder (  
    input clk,  
    input reset,  
    input input_bit,  
    output reg [1:0] output_bits  
);  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
        end else begin  
            output_bits <= {input_bit ^ state[0], input_bit ^ state[1]};  
            state <= {state[0], input_bit};  
        end  
    end  
endmodule