module top_module(
        input clk,
        input RegWrite,
        input [31:0]idat,
        output reg[31:0]odat
    );reg[31:0] kdat;

    always @(negedge clk) begin
        if (RegWrite) kdat <= idat;
    end

    always @(posedge clk) begin
		odat = kdat;
    end


endmodule