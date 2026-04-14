module top_module(
    // Inputs from init block
    input       [ 5:0]  init_dprio_address,
    input               init_dprio_read,
    input       [ 1:0]  init_dprio_byteen,
    input               init_dprio_write,
    input       [15:0]  init_dprio_writedata,

    input               init_atpgmode,
    input               init_mdio_dis,
    input               init_scanen,
    input               init_ser_shift_load,
    input               dprio_init_done,

    // Inputs from avmm master
    input       [ 5:0]  avmm_dprio_address,
    input               avmm_dprio_read,
    input       [ 1:0]  avmm_dprio_byteen,
    input               avmm_dprio_write,
    input       [15:0]  avmm_dprio_writedata,

    input               avmm_atpgmode,
    input               avmm_mdio_dis,
    input               avmm_scanen,
    input               avmm_ser_shift_load,

    // Outputs to fpll
    output      [ 5:0]  dprio_address,
    output              dprio_read,
    output      [ 1:0]  dprio_byteen,
    output              dprio_write,
    output      [15:0]  dprio_writedata,

    output              atpgmode,
    output              mdio_dis,
    output              scanen,
    output              ser_shift_load
);// Multiplex inputs from init block and AVMM master
    assign  dprio_address   = dprio_init_done ? avmm_dprio_address    : init_dprio_address;
    assign  dprio_read      = dprio_init_done ? avmm_dprio_read       : init_dprio_read;
    assign  dprio_byteen    = dprio_init_done ? avmm_dprio_byteen     : init_dprio_byteen;
    assign  dprio_write     = dprio_init_done ? avmm_dprio_write      : init_dprio_write;
    assign  dprio_writedata = dprio_init_done ? avmm_dprio_writedata  : init_dprio_writedata;

    assign  atpgmode        = init_atpgmode;
    assign  scanen          = init_scanen;
    assign  mdio_dis        = init_mdio_dis;
    assign  ser_shift_load  = init_ser_shift_load ;
endmodule