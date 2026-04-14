module priority_encoder_16bit (
    input wire [15:0] a,
    output reg [3:0] y,
    output reg valid
);

    always @(*) begin
        valid = 1'b0;
        y = 4'd0;
        if (a[15]) begin
            y = 4'd15;
            valid = 1'b1;
        end else if (a[14]) begin
            y = 4'd14;
            valid = 1'b1;
        end else if (a[13]) begin
            y = 4'd13;
            valid = 1'b1;
        end else if (a[12]) begin
            y = 4'd12;
            valid = 1'b1;
        end else if (a[11]) begin
            y = 4'd11;
            valid = 1'b1;
        end else if (a[10]) begin
            y = 4'd10;
            valid = 1'b1;
        end else if (a[9]) begin
            y = 4'd9;
            valid = 1'b1;
        end else if (a[8]) begin
            y = 4'd8;
            valid = 1'b1;
        end else if (a[7]) begin
            y = 4'd7;
            valid = 1'b1;
        end else if (a[6]) begin
            y = 4'd6;
            valid = 1'b1;
        end else if (a[5]) begin
            y = 4'd5;
            valid = 1'b1;
        end else if (a[4]) begin
            y = 4'd4;
            valid = 1'b1;
        end else if (a[3]) begin
            y = 4'd3;
            valid = 1'b1;
        end else if (a[2]) begin
            y = 4'd2;
            valid = 1'b1;
        end else if (a[1]) begin
            y = 4'd1;
            valid = 1'b1;
        end else if (a[0]) begin
            y = 4'd0;
            valid = 1'b1;
        end
    end

endmodule