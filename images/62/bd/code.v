module top_module(
    input clka,
    input wea,
    input [6:0] addra,
    input [31:0] dina,
    output reg [31:0] douta
);reg [31:0] memory [0:63];
    
    always @(posedge clka) begin
        if (wea) begin
            memory[addra] <= dina;
        end
        else begin
            douta <= memory[addra];
        end
    end

endmodule