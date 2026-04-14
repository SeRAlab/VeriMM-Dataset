module sd_card_interface(  
    input [4:0] command,  
    output [4:0] response  
);  
    assign response = command + 1;  
endmodule