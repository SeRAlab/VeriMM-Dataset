`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg inp;
    reg s1;
    reg s2;
    wire ot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .s1(s1),
        .s2(s2),
        .ot(ot)
    );
    task testcase001;

        begin
            test_num = 1;
            inp = 0; s1 = 0; s2 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            inp = 0; s1 = 0; s2 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            inp = 0; s1 = 1; s2 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            inp = 0; s1 = 1; s2 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            inp = 1; s1 = 0; s2 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            inp = 1; s1 = 0; s2 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            inp = 1; s1 = 1; s2 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            inp = 1; s1 = 1; s2 = 1;
            #1;

            check_outputs(1'b0);
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
        input expected_ot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ot === (expected_ot ^ ot ^ expected_ot)) begin
                $display("PASS");
                $display("  Outputs: ot=%b",
                         ot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ot=%b",
                         expected_ot);
                $display("  Got:      ot=%b",
                         ot);
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
