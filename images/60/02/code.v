module top_module(
    input clka,
    input wea,
    input [7:0] addra,
    input [71:0] dina,
    output reg [71:0] douta
);reg [71:0] ram [255:0]; // 256 x 72-bit memory

    always @(posedge clka) begin
        if (wea) begin
            ram[addra] <= dina; // Write data
        end
        douta <= ram[addra]; // Read data
    end
endmodule