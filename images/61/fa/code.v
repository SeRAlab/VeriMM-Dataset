module top_module(
    input enable_memorycard,
    input enable_ac97,
    input enable_pfpu,
    input enable_tmu,
    input enable_ethernet,
    input enable_fmlmeter,
    input enable_videoin,
    input enable_midi,
    input enable_dmx,
    input enable_ir,
    input enable_usb,
    input enable_memtest,
    input enable_aceusb,
    input enable_ps2keyboard,
    input enable_ps2mouse,
    output [31:0] capabilities
);assign capabilities = {
    17'd0,
    enable_ps2mouse,
    enable_ps2keyboard,
    enable_aceusb,
    enable_memtest,
    enable_usb,
    enable_ir,
    enable_dmx,
    enable_midi,
    enable_videoin,
    enable_fmlmeter,
    enable_ethernet,
    enable_tmu,
    enable_pfpu,
    enable_ac97,
    enable_memorycard
};

endmodule