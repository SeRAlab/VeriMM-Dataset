module verified_mux_2to1(
    input [7:0] data_in0,
    input [7:0] data_in1,
    input sel,
    
    output reg [7:0] data_out
);
    always @(*) begin
        if (sel == 1'b0)
            data_out = data_in0;
        else
            data_out = data_in1;
    end
endmodule