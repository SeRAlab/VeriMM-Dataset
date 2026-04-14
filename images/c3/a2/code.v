module mux4x1(data0, data1, data2, data3, selectInput, out);
    
    output reg [7:0] out;
    input [7:0] data0, data1, data2, data3;
    input [1:0] selectInput;

    always @(*) begin
        case (selectInput)
            2'b00: out = data0;
            2'b01: out = data1;
            2'b10: out = data2;
            2'b11: out = data3;
        endcase
    end

endmodule