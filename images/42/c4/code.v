module top_module(
                                      
                                       byte_access,
                                       hw,
                                       word,
                                       write_address,

                                      
                                       write_byteenable
                                    )
;output  [  3: 0] write_byteenable;
  input            byte_access;
  input            hw;
  input            word;
  input   [ 10: 0] write_address;

  wire             wa_1_is_0;
  wire             wa_1_is_1;
  wire             wa_1_to_0_is_0;
  wire             wa_1_to_0_is_1;
  wire             wa_1_to_0_is_2;
  wire             wa_1_to_0_is_3;
  wire    [  3: 0] write_byteenable;
  assign wa_1_to_0_is_3 = write_address[1 : 0] == 2'h3;
  assign wa_1_to_0_is_2 = write_address[1 : 0] == 2'h2;
  assign wa_1_to_0_is_1 = write_address[1 : 0] == 2'h1;
  assign wa_1_to_0_is_0 = write_address[1 : 0] == 2'h0;
  assign wa_1_is_1 = write_address[1] == 1'h1;
  assign wa_1_is_0 = write_address[1] == 1'h0;
  assign write_byteenable = ({4 {byte_access}} & {wa_1_to_0_is_3, wa_1_to_0_is_2, wa_1_to_0_is_1, wa_1_to_0_is_0}) |
    ({4 {hw}} & {wa_1_is_1, wa_1_is_1, wa_1_is_0, wa_1_is_0}) |
    ({4 {word}} & 4'b1111);


endmodule