`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_Flush_i;
    reg MemtoReg_i;
    reg RegWrite_i;
    wire MemtoReg_o;
    wire RegWrite_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_Flush_i(EX_Flush_i),
        .MemtoReg_i(MemtoReg_i),
        .RegWrite_i(RegWrite_i),
        .MemtoReg_o(MemtoReg_o),
        .RegWrite_o(RegWrite_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: EX_Flush=0, RegWrite_i=0, MemtoReg_i=0", test_num);
            EX_Flush_i = 0;
            RegWrite_i = 0;
            MemtoReg_i = 0;
            #10;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: EX_Flush=0, RegWrite_i=1, MemtoReg_i=0", test_num);
            EX_Flush_i = 0;
            RegWrite_i = 1;
            MemtoReg_i = 0;
            #10;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: EX_Flush=0, RegWrite_i=0, MemtoReg_i=1", test_num);
            EX_Flush_i = 0;
            RegWrite_i = 0;
            MemtoReg_i = 1;
            #10;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: EX_Flush=0, RegWrite_i=1, MemtoReg_i=1", test_num);
            EX_Flush_i = 0;
            RegWrite_i = 1;
            MemtoReg_i = 1;
            #10;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: EX_Flush=1, RegWrite_i=1, MemtoReg_i=1 (Expect 0)", test_num);
            EX_Flush_i = 1;
            RegWrite_i = 1;
            MemtoReg_i = 1;
            #10;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: EX_Flush=1, RegWrite_i=0, MemtoReg_i=1 (Expect 0)", test_num);
            EX_Flush_i = 1;
            RegWrite_i = 0;
            MemtoReg_i = 1;
            #10;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Dynamic transition to Flush", test_num);

            EX_Flush_i = 0;
            RegWrite_i = 1;
            MemtoReg_i = 0;
            #5;

            EX_Flush_i = 1;
            #5;
            #1;

            check_outputs(0, 0);
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
        input expected_MemtoReg_o;
        input expected_RegWrite_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MemtoReg_o === (expected_MemtoReg_o ^ MemtoReg_o ^ expected_MemtoReg_o) &&
                expected_RegWrite_o === (expected_RegWrite_o ^ RegWrite_o ^ expected_RegWrite_o)) begin
                $display("PASS");
                $display("  Outputs: MemtoReg_o=%b, RegWrite_o=%b",
                         MemtoReg_o, RegWrite_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MemtoReg_o=%b, RegWrite_o=%b",
                         expected_MemtoReg_o, expected_RegWrite_o);
                $display("  Got:      MemtoReg_o=%b, RegWrite_o=%b",
                         MemtoReg_o, RegWrite_o);
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
