module priority_encoder_8bit(
    input [7:0]         data_in  ,
    output reg [2:0]    data_out ,
    output reg          valid    
);

always @(*) begin
    valid = |data_in;
    if (data_in[7])
        data_out = 3'd7;
    else if (data_in[6])
        data_out = 3'd6;
    else if (data_in[5])
        data_out = 3'd5;
    else if (data_in[4])
        data_out = 3'd4;
    else if (data_in[3])
        data_out = 3'd3;
    else if (data_in[2])
        data_out = 3'd2;
    else if (data_in[1])
        data_out = 3'd1;
    else if (data_in[0])
        data_out = 3'd0;
    else
        data_out = 3'd0;
end

endmodule