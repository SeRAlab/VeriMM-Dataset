module openhmc_ram #(
        parameter DATASIZE  = 78,   
        parameter ADDRSIZE  = 9,    
        parameter PIPELINED = 0     
    ) (
        input wire                  clk,
        input wire                  wen,
        input wire [DATASIZE-1:0]   wdata,
        input wire [ADDRSIZE-1:0]   waddr,
        input wire                  ren,
        input wire [ADDRSIZE-1:0]   raddr,
        output wire [DATASIZE-1:0]  rdata
    );
    wire [DATASIZE-1:0] rdata_ram;
    generate
        if (PIPELINED == 0)
        begin
            assign rdata    = rdata_ram;
        end
        else
        begin
            reg [DATASIZE-1:0]  rdata_dly;
            reg                 ren_dly;
            assign rdata    = rdata_dly;
            always @(posedge clk)
            begin
                ren_dly         <= ren;
                if (ren_dly)
                    rdata_dly   <= rdata_ram;
            end
        end
    endgenerate
    reg [DATASIZE-1:0]  MEM [0:(2**ADDRSIZE)-1];
    reg [DATASIZE-1:0]  data_out;
    assign rdata_ram = data_out;
    always @(posedge clk)
    begin
        if (wen)
            MEM[waddr]  <= wdata;
    end
    always @(posedge clk)
    begin
        if (ren)
            data_out    <= MEM[raddr];
    end
endmodule