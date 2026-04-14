module BiDirShiftReg_4(
   input           clk,
   input           rst,
   input           SI_L,
   input           SI_R,
   input           dir,
   output [3:0]    Q  
);
    reg [3:0] reg_Q;
    
    always@(posedge clk) begin
        if(rst) reg_Q <= 4'b0; // Reset the register
        else if(dir) reg_Q <= {reg_Q[2:0], SI_L}; // Shift left
        else reg_Q <= {SI_R, reg_Q[3:1]}; // Shift right
    end
    
    assign Q = reg_Q; // Parallel output is the current value of the register
endmodule