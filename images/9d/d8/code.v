module top_module(
    input select,
    input [63:0] key,
    output reg [27:0] lefto,
    output reg [27:0] righto
);reg [63:0] temp;

// Perform permutation if select is 1, else pass input key as is
always @(*) begin
    if (select == 1) begin
        temp = { key[57], key[49], key[41], key[33], key[25], key[17], key[9], key[1],
                  key[58], key[50], key[42], key[34], key[26], key[18], key[10], key[2],
                  key[59], key[51], key[43], key[35], key[27], key[19], key[11], key[3],
                  key[62], key[54], key[46], key[38], key[30], key[22], key[14], key[6], 
                  key[61], key[53], key[45], key[37], key[29], key[21], key[13], key[5],
                  key[60], key[52], key[44], key[36], key[28], key[20], key[12], key[4],
                  key[63], key[55], key[47], key[39], key[31], key[23], key[15], key[7] };
    end else begin
        temp = key;
    end
end

// Split the key into left and right halves
always @(*) begin
    lefto = temp[63:36];  // Changed size to [27:0]
    righto = temp[35:8];  // Changed size to [27:0]
end

endmodule