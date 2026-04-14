module top_module(input clk, input [5:0] din, output dout);parameter LOC = "";

    (* LOC=LOC *)
    reg [31:0] ram [0:31]; // 32x1 RAM

    always @(posedge clk) begin
        ram[{din[4:0]}] <= din[5]; // write to specified address
    end

    assign dout = ram[{din[4:0]}]; // read from specified address
endmodule