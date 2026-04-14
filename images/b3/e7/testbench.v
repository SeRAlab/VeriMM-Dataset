`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e1;
    reg e2;
    reg e3;
    reg e4;
    wire e_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e1(e1),
        .e2(e2),
        .e3(e3),
        .e4(e4),
        .e_out(e_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs zero", test_num);
            e1 = 0; e2 = 0; e3 = 0; e4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: e4 high, others low", test_num);
            e1 = 0; e2 = 0; e3 = 0; e4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: NAND inputs high, e4 high (Full Path)", test_num);
            e1 = 1; e2 = 1; e3 = 1; e4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: NAND inputs high, e4 low", test_num);
            e1 = 1; e2 = 1; e3 = 1; e4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Partial NAND (e1 low), e4 high", test_num);
            e1 = 0; e2 = 1; e3 = 1; e4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Partial NAND (e2 low), e4 high", test_num);
            e1 = 1; e2 = 0; e3 = 1; e4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Partial NAND (e3 low), e4 high", test_num);
            e1 = 1; e2 = 1; e3 = 0; e4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mixed inputs, e4 low", test_num);
            e1 = 1; e2 = 0; e3 = 1; e4 = 0;
            #1;

            check_outputs(0);
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
        input expected_e_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_e_out === (expected_e_out ^ e_out ^ expected_e_out)) begin
                $display("PASS");
                $display("  Outputs: e_out=%b",
                         e_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e_out=%b",
                         expected_e_out);
                $display("  Got:      e_out=%b",
                         e_out);
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
