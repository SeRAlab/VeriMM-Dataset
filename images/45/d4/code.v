module top_module(opcode, jr, rdM, rsD, mux);output reg mux;
    input [5:0] opcode, jr;
    input [4:0]  rdM, rsD;
    
    
    always @(*) begin
        mux<=0;
        if((opcode==6'b0) && (jr== 6'b001000) && (rdM==rsD) ) begin
            mux<=1;
        end
    end
endmodule