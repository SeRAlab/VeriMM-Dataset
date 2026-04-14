module top_module(
                                                 
                                                  ctrl,

                                                 
                                                  td_mode
                                               )
;output  [  3: 0] td_mode;
  input   [  8: 0] ctrl;

  wire    [  2: 0] ctrl_bits_for_mux;
  reg     [  3: 0] td_mode;
  assign ctrl_bits_for_mux = ctrl[7 : 5];
  always @(ctrl_bits_for_mux)
    begin
      case (ctrl_bits_for_mux)
      
          3'b000: begin
              td_mode = 4'b0000;
          end 
      
          3'b001: begin
              td_mode = 4'b1000;
          end 
      
          3'b010: begin
              td_mode = 4'b0100;
          end 
      
          3'b011: begin
              td_mode = 4'b1100;
          end 
      
          3'b100: begin
              td_mode = 4'b0010;
          end 
      
          3'b101: begin
              td_mode = 4'b1010;
          end 
      
          3'b110: begin
              td_mode = 4'b0101;
          end 
      
          3'b111: begin
              td_mode = 4'b1111;
          end 
      
      endcase 
    end



endmodule