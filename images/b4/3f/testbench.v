`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] exmem_Rd;
    reg exmem_RegWrite;
    reg [4:0] idex_Rs;
    reg [4:0] idex_Rt;
    reg [4:0] memwb_Rd;
    reg memwb_RegWrite;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exmem_Rd(exmem_Rd),
        .exmem_RegWrite(exmem_RegWrite),
        .idex_Rs(idex_Rs),
        .idex_Rt(idex_Rt),
        .memwb_Rd(memwb_Rd),
        .memwb_RegWrite(memwb_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No Hazard - Different Registers", test_num);
        idex_Rs = 5'd1;
        idex_Rt = 5'd2;
        exmem_Rd = 5'd3;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd4;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: EX Hazard on Rs", test_num);
        idex_Rs = 5'd10;
        idex_Rt = 5'd11;
        exmem_Rd = 5'd10;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd12;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: EX Hazard on Rt", test_num);
        idex_Rs = 5'd10;
        idex_Rt = 5'd11;
        exmem_Rd = 5'd11;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd12;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: MEM Hazard on Rs", test_num);
        idex_Rs = 5'd15;
        idex_Rt = 5'd16;
        exmem_Rd = 5'd17;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd15;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: MEM Hazard on Rt", test_num);
        idex_Rs = 5'd15;
        idex_Rt = 5'd16;
        exmem_Rd = 5'd17;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd16;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: EX and MEM Hazard Overlap on Rs (EX Priority)", test_num);


        idex_Rs = 5'd20;
        idex_Rt = 5'd21;
        exmem_Rd = 5'd20;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd20;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Register 0 Check (Should Not Forward)", test_num);

        idex_Rs = 5'd0;
        idex_Rt = 5'd0;
        exmem_Rd = 5'd0;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd0;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: RegWrite Signal Check", test_num);

        idex_Rs = 5'd5;
        idex_Rt = 5'd6;
        exmem_Rd = 5'd5;
        exmem_RegWrite = 1'b0;
        memwb_Rd = 5'd6;
        memwb_RegWrite = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Mixed EX and MEM Hazards", test_num);
        idex_Rs = 5'd1;
        idex_Rt = 5'd2;
        exmem_Rd = 5'd1;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd2;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: MEM Hazard with EX Write to different register", test_num);
        idex_Rs = 5'd4;
        idex_Rt = 5'd5;
        exmem_Rd = 5'd10;
        exmem_RegWrite = 1'b1;
        memwb_Rd = 5'd4;
        memwb_RegWrite = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [1:0] expected_ForwardA;
        input [1:0] expected_ForwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%h, ForwardB=%h",
                         expected_ForwardA, expected_ForwardB);
                $display("  Got:      ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
