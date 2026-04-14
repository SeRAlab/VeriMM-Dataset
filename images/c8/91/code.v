module two_bit_encoder
    ( 
    input   [1:0]  data,
    output  reg    q
    );

    always @(*)
    begin
        if (data == 2'b10)
            q = 1'b0;
        else
            q = data[1];
    end

endmodule