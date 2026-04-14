module top_module(
    input [7:0] Dato_RTC, 
    input [7:0] Dato_Boton, 
    input Select,
    output [7:0] Dato_vga 
    );assign Dato_vga = Select ? Dato_RTC : Dato_Boton; 

endmodule