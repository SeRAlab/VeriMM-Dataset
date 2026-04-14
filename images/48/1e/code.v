module top_module(
    input [31:0] OldAddress,
    input [31:0] AddressOffset,
    output reg [31:0] NewAddress
    );always @ (OldAddress or AddressOffset) begin
        NewAddress = (AddressOffset << 2) + OldAddress;        
    end
    
endmodule