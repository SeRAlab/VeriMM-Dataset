module priority_encoder_8to3(
    input       [7:0]     data_in,
    
    output reg            valid,
    output reg  [2:0]     encoded
);

// Priority encoder implementation
always @(*) begin
    if (data_in[7])
        encoded = 3'd7;
    else if (data_in[6])
        encoded = 3'd6;
    else if (data_in[5])
        encoded = 3'd5;
    else if (data_in[4])
        encoded = 3'd4;
    else if (data_in[3])
        encoded = 3'd3;
    else if (data_in[2])
        encoded = 3'd2;
    else if (data_in[1])
        encoded = 3'd1;
    else if (data_in[0])
        encoded = 3'd0;
    else
        encoded = 3'd0;

    valid = (data_in != 8'd0);
end

endmodule