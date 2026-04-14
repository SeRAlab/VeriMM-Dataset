module packet_filter(
    input [4:0] packet_type,
    input [4:0] allowed_types,
    output reg allowed
);
    always @(*) begin
        if (allowed_types[packet_type]) 
            allowed = 1'b1; 
        else 
            allowed = 1'b0; 
    end
endmodule