module mux8to1(
    input   [7:0][7:0]  data_in ,
    input   [2:0]       select  ,
    output  reg [7:0]   data_out
);

    always @(*) begin
        case (select)
            3'b000: data_out = data_in[0];
            3'b001: data_out = data_in[1];
            3'b010: data_out = data_in[2];
            3'b011: data_out = data_in[3];
            3'b100: data_out = data_in[4];
            3'b101: data_out = data_in[5];
            3'b110: data_out = data_in[6];
            3'b111: data_out = data_in[7];
            default: data_out = 8'b0;
        endcase
    end
    
endmodule