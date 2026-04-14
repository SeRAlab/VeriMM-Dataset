module packet_filter(  
    input [15:0] packet,  
    input [2:0] filter_id,  
    output reg allow  
);  

always @(*) begin  
    case (filter_id)  
        3'b000: allow = (packet == 16'hAABB); // Allow specific packet  
        3'b001: allow = (packet == 16'hCCDD); // Allow another specific packet  
        3'b010: allow = (packet == 16'hFFFF); // Allow another specific packet  
        default: allow = 0; // Block all other packets  
    endcase  
end  
endmodule