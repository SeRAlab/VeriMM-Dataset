module mpc_controller(  
    input [9:0] ref,  
    input [9:0] pv,  
    input [3:0] gain,  
    output [9:0] control  
);  
    assign control = gain * (ref - pv);  
endmodule