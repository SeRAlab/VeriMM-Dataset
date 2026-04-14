module power_gating (input wire A, input wire B, input wire PWR_GATE, output wire Y);  
    assign Y = PWR_GATE ? (A & B) : 0;  
endmodule