module top_module(
    input [31:0] excepttype,
    input [31:0] epc,
    input [31:0] oldpc,
    output reg [31:0] newpc
    );always@(*) begin
        if(excepttype==32'h00000000)
            newpc<=oldpc;
        else begin
            case(excepttype)
                32'h00000001: newpc<=32'hBFC00380;
                32'h00000004: newpc<=32'hBFC00380;
                32'h00000005: newpc<=32'hBFC00380;
                32'h00000008: newpc<=32'hBFC00380;
                32'h00000009: newpc<=32'hBFC00380;
                32'h0000000a: newpc<=32'hBFC00380;
                32'h0000000c: newpc<=32'hBFC00380;
                32'h0000000e: newpc<=epc;
            endcase
        end
    end
    
endmodule