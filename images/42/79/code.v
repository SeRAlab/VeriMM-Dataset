module JohnsonCounter_4(
   input           clk,
   input           rst,
   output [3:0]    Q  
);
    reg [3:0] reg_Q;
    
    always@(posedge clk) begin
        if(rst) reg_Q <= 4'b0; // Reset the counter
        else reg_Q <= {~reg_Q[0], reg_Q[3:1]}; // Johnson counter operation
    end
    
    assign Q = reg_Q; // Parallel output is the current state of the counter
endmodule