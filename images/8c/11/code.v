module top_module(input        clk,
              input [1:0]  ctlwb_out, 
              input [2:0]  ctlm_out,
              input [31:0] adder_out,
              input        aluzero,
              input [31:0] aluout,
              input [31:0] readdat2,
              input [4:0]  muxout,
              output reg [1:0]  wb_ctlout,
              output reg [2:0]  m_ctlout,
              output reg [31:0] add_result,
              output reg        zero,
              output reg [31:0] alu_result,
              output reg [31:0] rdata2out,
              output reg [4:0]  five_bit_muxout);// Initialize.
    initial begin
        wb_ctlout <= 2'b0;
        m_ctlout <= 3'b0;
        add_result <= 32'b0;
        zero <= 1'b0;
        alu_result <= 32'b0;
        rdata2out <= 32'b0;
        five_bit_muxout  <= 5'b0;    
    end

    // Update.
    always @ (posedge clk) begin
        wb_ctlout <= ctlwb_out;
        m_ctlout <= ctlm_out;
        add_result <= adder_out;
        zero <= aluzero;
        alu_result <= aluout;
        rdata2out <= readdat2;
        five_bit_muxout  <= muxout;
    end
endmodule