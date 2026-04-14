module ethernet_frame_checker(
    input [11:0] frame_length,
    output reg is_valid
);
    always @(*) begin
        if (frame_length >= 12'd64 && frame_length <= 12'd1518) 
            is_valid = 1'b1; // Length is valid
        else 
            is_valid = 1'b0; // Length is invalid
    end
endmodule