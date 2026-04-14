module top_module(
    input wire clk,
    input wire rst_n,
    input wire [15:0] addr,
    input wire [15:0] data_in,
    input wire we,
    output wire [15:0] data_out
);wire [11:0] addr_l;
    assign addr_l=addr[9:0];
    reg [7:0] mem [1023:0]; 

    integer i;

    always @(posedge clk) begin
        if(!rst_n) begin
            for(i=0;i<1024;i=i+1)
                mem[i]<=8'h0;
        end else begin
            if(we) begin
                mem[addr_l]<=data_in[7:0];
                mem[addr_l+1]<=data_in[15:8];
            end
        end
    end

    assign data_out = {mem[addr_l+1],mem[addr_l]};

endmodule