module  omsp_scan_mux (
    data_out,                      
    data_in_scan,                  
    data_in_func,                  
    scan_mode                      
);
output              data_out;      
input               data_in_scan;  
input               data_in_func;  
input               scan_mode;     
assign  data_out  =  scan_mode ? data_in_scan : data_in_func;
endmodule