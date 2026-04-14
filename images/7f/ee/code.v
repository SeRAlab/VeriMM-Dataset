module top_module(
           input CLK,
           input [7:0] DIVIDER,
           input RST,
           output reg SD_CLK
       );reg [7:0] counter;

always @(posedge CLK or posedge RST)
begin
    if (RST) begin
        counter <= 8'b0000_0000;
        SD_CLK <= 0;
    end
    else if (counter == DIVIDER - 1) begin  // Changed to DIVIDER - 1
        counter <= 0;
        SD_CLK <= ~SD_CLK;
    end else begin
        counter <= counter + 1;
    end
end

// Removed the assign statement as SD_CLK is driven by the always block.

endmodule