module priority_encoder_12bit
(
    input [11:0] data_in,
    output reg [3:0] encoded,
    output reg valid
);

always @(*) begin
    valid = 1'b0;
    encoded = 4'd0;
    if (data_in[11]) begin
        encoded = 4'd11;
        valid = 1'b1;
    end else if (data_in[10]) begin
        encoded = 4'd10;
        valid = 1'b1;
    end else if (data_in[9]) begin
        encoded = 4'd9;
        valid = 1'b1;
    end else if (data_in[8]) begin
        encoded = 4'd8;
        valid = 1'b1;
    end else if (data_in[7]) begin
        encoded = 4'd7;
        valid = 1'b1;
    end else if (data_in[6]) begin
        encoded = 4'd6;
        valid = 1'b1;
    end else if (data_in[5]) begin
        encoded = 4'd5;
        valid = 1'b1;
    end else if (data_in[4]) begin
        encoded = 4'd4;
        valid = 1'b1;
    end else if (data_in[3]) begin
        encoded = 4'd3;
        valid = 1'b1;
    end else if (data_in[2]) begin
        encoded = 4'd2;
        valid = 1'b1;
    end else if (data_in[1]) begin
        encoded = 4'd1;
        valid = 1'b1;
    end else if (data_in[0]) begin
        encoded = 4'd0;
        valid = 1'b1;
    end
end

endmodule