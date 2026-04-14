module top_module(
    input [3:0] DI,
    input WCK, WRE,
    input [3:0] RAD,
    input [3:0] WAD,
    output [3:0] DO
);reg [3:0] ram[0:15];
    integer i;

    function [63:0] convert_initval;
        input [143:0] hex_initval;
        reg done;
        reg [63:0] temp;
        reg [7:0] char;
        integer i;
        begin
            done = 1'b0;
            temp = 0;
            for (i = 0; i < 16; i = i + 1) begin
                if (!done) begin
                    char = hex_initval[8*i +: 8];
                    if (char == "x") begin
                        done = 1'b1;
                    end else begin
                        if (char >= "0" && char <= "9")
                            temp[4*i +: 4] = char - "0";
                        else if (char >= "A" && char <= "F")
                            temp[4*i +: 4] = 10 + char - "A";
                        else if (char >= "a" && char <= "f")
                            temp[4*i +: 4] = 10 + char - "a";
                    end
                end
            end
            convert_initval = temp;
        end
    endfunction

    // Default initial value for the memory; use a parameter for customization
    parameter [143:0] INITVAL = { "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0" }; // Example initial value
    localparam conv_initval = convert_initval(INITVAL);

    initial begin
        for (i = 0; i < 16; i = i + 1) begin // Change 15 to 16 to initialize all memory locations
            ram[i] <= conv_initval[4*i +: 4];
        end
    end

    always @(posedge WCK) begin
        if (WRE) begin
            ram[WAD] <= DI;
        end
    end

    assign DO = (RAD > 15) ? 0 : ram[RAD];

endmodule