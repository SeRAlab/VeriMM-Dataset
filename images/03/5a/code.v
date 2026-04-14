module data_forwarding_mux(  
    input wire [3:0] D,  // Data inputs D0, D1, D2, D3  
    input wire [1:0] S,  // Select lines S0, S1  
    input wire F,        // Forwarding signal  
    output wire Y        // Output  
);  
    assign Y = (F) ? D : D[S]; // Forwarding logic  
endmodule