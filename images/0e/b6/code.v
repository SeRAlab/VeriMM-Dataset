module data_bus_mux (
    input [31:0] data_in0,
    input [31:0] data_in1,
    input [31:0] data_in2,
    input [31:0] data_in3,
    input [1:0] select,
    output reg [31:0] data_out
);
    
    always @(*) begin
        case (select)
            2'b00: data_out = data_in0;
            2'b01: data_out = data_in1;
            2'b10: data_out = data_in2;
            2'b11: data_out = data_in3;
            default: data_out = 32'b0; // Default case
        endcase
    end
endmodule