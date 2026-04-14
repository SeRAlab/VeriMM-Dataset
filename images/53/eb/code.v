module top_module(
    input [15:0] addr_in,
    input rd_in, send_addr,
    output reg [15:0] addr,
    output rd
    );assign rd=~rd_in;
    always @ (negedge send_addr)
    begin
        if(!send_addr)
        begin
            addr=addr_in;
        end
    end
endmodule