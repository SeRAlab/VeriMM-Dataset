module top_module(
    input clock,
    input reset,
    input [4:0] addra,
    output reg [31:0] dataa,
    input [4:0] addrb,
    output reg [31:0] datab,
    input enc,
    input [4:0] addrc,
    input [31:0] datac
);integer i;
    reg [31:0] registers [31:0];

    always @ (negedge reset) begin
        for (i=0; i<32; i=i+1) begin
            registers[i] <= 32'd0;
        end
    end

    always @ (posedge clock) begin
        dataa <= registers[addra];
        datab <= registers[addrb];
        if (enc) begin
            registers[addrc] <= datac;
        end
    end

endmodule