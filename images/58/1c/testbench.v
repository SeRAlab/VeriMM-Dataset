`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MEMRegWrite;
    reg [4:0] EX_MEMRegisterRd;
    reg [4:0] ID_EXRegisterRs;
    reg [4:0] ID_EXRegisterRt;
    reg MEM_WBRegWrite;
    reg [4:0] MEM_WBRegisterRd;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEMRegWrite(EX_MEMRegWrite),
        .EX_MEMRegisterRd(EX_MEMRegisterRd),
        .ID_EXRegisterRs(ID_EXRegisterRs),
        .ID_EXRegisterRt(ID_EXRegisterRt),
        .MEM_WBRegWrite(MEM_WBRegWrite),
        .MEM_WBRegisterRd(MEM_WBRegisterRd),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Hazards (All zeros)", test_num);
            EX_MEMRegWrite = 0;
            MEM_WBRegWrite = 0;
            EX_MEMRegisterRd = 0;
            MEM_WBRegisterRd = 0;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard on Rs", test_num);
            EX_MEMRegWrite = 1;
            EX_MEMRegisterRd = 5;
            MEM_WBRegWrite = 0;
            MEM_WBRegisterRd = 0;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard on Rt", test_num);
            EX_MEMRegWrite = 1;
            EX_MEMRegisterRd = 6;
            MEM_WBRegWrite = 0;
            MEM_WBRegisterRd = 0;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MEM Hazard on Rs", test_num);
            EX_MEMRegWrite = 0;
            EX_MEMRegisterRd = 0;
            MEM_WBRegWrite = 1;
            MEM_WBRegisterRd = 5;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MEM Hazard on Rt", test_num);
            EX_MEMRegWrite = 0;
            EX_MEMRegisterRd = 0;
            MEM_WBRegWrite = 1;
            MEM_WBRegisterRd = 6;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Hazard on Rs (EX Priority)", test_num);
            EX_MEMRegWrite = 1;
            EX_MEMRegisterRd = 5;
            MEM_WBRegWrite = 1;
            MEM_WBRegisterRd = 5;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;

            #1;


            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Hazard on Rt (EX Priority)", test_num);
            EX_MEMRegWrite = 1;
            EX_MEMRegisterRd = 6;
            MEM_WBRegWrite = 1;
            MEM_WBRegisterRd = 6;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No forwarding for Register 0", test_num);
            EX_MEMRegWrite = 1;
            EX_MEMRegisterRd = 0;
            MEM_WBRegWrite = 1;
            MEM_WBRegisterRd = 0;
            ID_EXRegisterRs = 0;
            ID_EXRegisterRt = 0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RegWrite is False (No Forwarding)", test_num);
            EX_MEMRegWrite = 0;
            EX_MEMRegisterRd = 5;
            MEM_WBRegWrite = 0;
            MEM_WBRegisterRd = 6;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Combined EX Hazard (Rs) and MEM Hazard (Rt)", test_num);
            EX_MEMRegWrite = 1;
            EX_MEMRegisterRd = 5;
            MEM_WBRegWrite = 1;
            MEM_WBRegisterRd = 6;
            ID_EXRegisterRs = 5;
            ID_EXRegisterRt = 6;
            #1;

            check_outputs(2'b10, 2'b01);
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
