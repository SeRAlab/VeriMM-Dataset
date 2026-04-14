module top_module(input iCLK, input iWRSFR, input [7:0] iDTBUS, input [3:0] iSSFRR, output [7:0] oGPO);reg [7:0] rGPO = 8'h00; 
  assign oGPO = rGPO; 
  
  always @(posedge iCLK) begin 
    if (iWRSFR && (iSSFRR == 4'h1)) begin // Fixed the hex constant to 4'h1
      rGPO <= iDTBUS; 
    end 
    // Removed the 'else' block as it is redundant. The previous value remains unchanged by default.
  end 
endmodule