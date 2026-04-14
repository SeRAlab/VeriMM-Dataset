module ring_counter(  
    input clk,  
    input reset,  
    output reg [4:0] counter_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            counter_out <= 5'b00001; // Initialize to '00001' on reset  
        else  
            counter_out <= {counter_out[3:0], counter_out[4]}; // Rotate left  
    end  
endmodule