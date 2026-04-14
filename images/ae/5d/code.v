module top_module( Q, scQ, 
     CDN, CK, D, SE, SI );output  Q, scQ;

input  CDN, CK, D, SE, SI;

wire Q, net023, se_n, SI, D;
reg  scQ;

assign se_n = !SE;
assign Q = scQ;
assign net023 = se_n ? D : SI;

always@(posedge CK or negedge CDN) begin
        if (!CDN) begin
                scQ <= 1'b0;
        end
        else begin
                scQ <= net023;
        end
end

endmodule