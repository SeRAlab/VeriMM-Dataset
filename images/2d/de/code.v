module crc_check (
    input [3:0] data,
    input [3:0] crc,
    output reg valid
);
    wire [3:0] crc_calc;
    assign crc_calc = data ^ (data >> 1) ^ (data >> 2) ^ (data >> 3);
    
    always @(*) begin
        if (crc_calc == crc)
            valid = 1;
        else
            valid = 0;
    end
endmodule