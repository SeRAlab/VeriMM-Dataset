module top_module(
    clka, cena_i, oena_i, wena_i, addra_i, dataa_i, dataa_o,
    clkb, cenb_i, oenb_i, wenb_i, addrb_i, datab_i, datab_o
);parameter Word_Width = 32;
    parameter Addr_Width = 6;

    input clka, clkb;
    input cena_i, oena_i, wena_i;
    input cenb_i, oenb_i, wenb_i;
    input [Addr_Width-1:0] addra_i, addrb_i;
    input [Word_Width-1:0] dataa_i, datab_i;
    output [Word_Width-1:0] dataa_o, datab_o;

    reg [Word_Width-1:0] mem_array[(1<<Addr_Width)-1:0];
    reg [Word_Width-1:0] dataa_r, datab_r;

    always @(posedge clka) begin
        if (!cena_i && !wena_i)
            mem_array[addra_i] <= dataa_i;
    end

    always @(posedge clka) begin
        if (!cena_i && wena_i)
            dataa_r <= mem_array[addra_i];
        else
            dataa_r <= 'bx;
    end

    assign dataa_o = oena_i ? 'bz : dataa_r;

    always @(posedge clkb) begin
        if (!cenb_i && !wenb_i)
            mem_array[addrb_i] <= datab_i;
    end

    always @(posedge clkb) begin
        if (!cenb_i && wenb_i)
            datab_r <= mem_array[addrb_i];
        else
            datab_r <= 'bx;
    end

    assign datab_o = oenb_i ? 'bz : datab_r;

endmodule