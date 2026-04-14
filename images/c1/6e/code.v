module fm_cmn_ram (
    clka,
    clkb,
    wea,
    addra,
    addrb,
    dia,
    doa,
    dob
 );
    parameter P_RAM_TYPE="TYPE_A";
    parameter P_WIDTH = 32;
    parameter P_RANGE = 2;
    parameter P_DEPTH = 1 << P_RANGE;
    input                clka;
    input                clkb;
    input                wea;
    input  [P_RANGE-1:0] addra;
    input  [P_RANGE-1:0] addrb;
    input  [P_WIDTH-1:0] dia;
    output [P_WIDTH-1:0] doa;
    output [P_WIDTH-1:0] dob;
    reg [P_WIDTH-1:0] ram [P_DEPTH-1:0];
    reg [P_WIDTH-1:0] doa;
    reg [P_WIDTH-1:0] dob;
generate
  if (P_RAM_TYPE=="TYPE_A") begin
    always @(posedge clka) begin
        if (wea) ram[addra] <= dia;
    end
    always @(posedge clkb) begin
        dob <= ram[addrb];
    end
  end else begin
    always @(posedge clka) begin
        if (wea) begin
            ram[addra] <= dia;
            doa <= dia;
        end else begin
            doa <= ram[addra];
        end
    end
    always @(posedge clkb) begin
        dob <= ram[addrb];
    end
  end
endgenerate
endmodule