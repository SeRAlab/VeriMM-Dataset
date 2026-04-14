module top_module(INPUT__TVALID, INPUT__TREADY, INPUT__TLAST, OUTPUT__TDATA, OUTPUT__TVALID, OUTPUT__TREADY, OUTPUT__TLAST, INPUT__TDATA);(* src = "./test_case.py:20" *)
  output [15:0] INPUT__TDATA;
  (* src = "./test_case.py:20" *)
  output INPUT__TLAST;
  (* src = "./test_case.py:20" *)
  input INPUT__TREADY;
  (* src = "./test_case.py:20" *)
  output INPUT__TVALID;
  (* src = "./test_case.py:20" *)
  input [15:0] OUTPUT__TDATA;
  (* src = "./test_case.py:20" *)
  input OUTPUT__TLAST;
  (* src = "./test_case.py:20" *)
  output OUTPUT__TREADY;
  (* src = "./test_case.py:20" *)
  input OUTPUT__TVALID;
  assign INPUT__TLAST = OUTPUT__TLAST;
  assign OUTPUT__TREADY = INPUT__TREADY;
  assign INPUT__TVALID = OUTPUT__TVALID;
  assign INPUT__TDATA = OUTPUT__TDATA;
endmodule