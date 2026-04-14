module fixed_priority_arbiter (  
    input wire clk,  
    input wire reset,  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    output reg grant  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        grant <= 0;  
    end else begin  
        case ({req0, req1, req2})  
            3'b100: grant <= 3'b100; // req0 has highest priority  
            3'b010: grant <= 3'b010; // req1 has second priority  
            3'b001: grant <= 3'b001; // req2 has lowest priority  
            default: grant <= 0;     // no requests  
        endcase  
    end  
end  
endmodule