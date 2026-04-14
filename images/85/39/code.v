module top_module(

        (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
        input M_SEL,

        input M_IN_0,

        input M_IN_1,

        output M_OUT
    );assign M_OUT = M_SEL ? M_IN_1 : M_IN_0;
endmodule