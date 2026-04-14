module SRAM_4bit (
    input [3:0] data,
    input we, // write enable
    input re, // read enable
    output reg [3:0] q // output data
);
    reg [3:0] storage; // storage for the SRAM cell

    always @(posedge we or posedge re) begin
        if (we) begin
            storage <= data; // write data to storage
        end
    end

    always @(posedge re) begin
        q <= storage; // read data from storage
    end
endmodule