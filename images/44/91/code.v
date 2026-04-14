module USR_8(
   input           clk,
   input           rst,
   input           SI_L,
   input           SI_R,
   input [7:0]     PI,
   input           load,
   input           shift,
   input           dir,
   output [7:0]    Q  
);
    reg [7:0] reg_Q;
    
    always@(posedge clk) begin
        if(rst) reg_Q <= 8'b0; // Reset the register
        else if(load) reg_Q <= PI; // Load parallel input
        else if(shift) begin
            if(dir) reg_Q <= {reg_Q[6:0], SI_L}; // Shift left
            else reg_Q <= {SI_R, reg_Q[7:1]}; // Shift right
        end
    end
    
    assign Q = reg_Q; // Parallel output is the current value of the register
endmodule