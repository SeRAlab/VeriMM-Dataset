module top_module(
    input wire iPAGING_ENA,
    input wire iKERNEL_ACCESS,
    input wire [13:0] iMMU_FLAGS,
    output wire [2:0] oIRQ40,
    output wire [2:0] oIRQ41,
    output wire [2:0] oIRQ42
);function [2:0] func_mmu_flags_fault_check;
        input func_paging;
        input func_kernel;              //1:kernel mode
        input [5:0] func_mmu_flags;
        begin
            case ({func_paging, func_kernel})
                2'b00: func_mmu_flags_fault_check = 3'b000;  // No paging, no IRQs
                2'b01: func_mmu_flags_fault_check = 3'b000;  // User mode, no IRQs
                2'b10: begin                                 // Kernel mode
                    if (func_mmu_flags[0])                   // Page fault
                        func_mmu_flags_fault_check = 3'b001;
                    else if (func_mmu_flags[4])              // Invalid instruction
                        func_mmu_flags_fault_check = 3'b100;
                    else
                        func_mmu_flags_fault_check = 3'b000;
                end
                2'b11: begin                                 // User mode
                    if (func_mmu_flags[0])                   // Page fault
                        func_mmu_flags_fault_check = 3'b001;
                    else if (func_mmu_flags[5:4] == 2'b00)   // U/S = 0
                        func_mmu_flags_fault_check = 3'b010;
                    else
                        func_mmu_flags_fault_check = 3'b000;
                end
            endcase
        end
    endfunction

    assign {oIRQ42, oIRQ41, oIRQ40} = func_mmu_flags_fault_check(iPAGING_ENA, iKERNEL_ACCESS, iMMU_FLAGS[5:0]);

endmodule