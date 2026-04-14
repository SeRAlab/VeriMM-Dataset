module top_module(
    input wire Clk,
    input wire Clear_in,
    input wire Enable_in,
    output reg [3:0] GrayCount_out
);reg [3:0] BinaryCount; // binary count
    
    always @(posedge Clk) begin
        if (Clear_in) begin
            BinaryCount <= 4'b0001;
            GrayCount_out <= 4'b0000;
        end
        else if (Enable_in) begin
            BinaryCount <= BinaryCount + 1;
            GrayCount_out <= {BinaryCount[3], BinaryCount[3] ^ BinaryCount[2], BinaryCount[2] ^ BinaryCount[1], BinaryCount[1] ^ BinaryCount[0]};
        end
    end
endmodule