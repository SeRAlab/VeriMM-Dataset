`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] J1;
    wire [7:0] J3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .J1(J1),
        .J3(J3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input zero (8'h00)", test_num);
            J1 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input all ones (8'hFF)", test_num);
            J1 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input alternating pattern AA (8'hAA)", test_num);
            J1 = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input alternating pattern 55 (8'h55)", test_num);
            J1 = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input random pattern A5 (8'hA5)", test_num);
            J1 = 8'hA5;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input random pattern 12 (8'h12)", test_num);
            J1 = 8'h12;
            #1;

            check_outputs(8'h12);
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
        input [7:0] expected_J3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_J3 === (expected_J3 ^ J3 ^ expected_J3)) begin
                $display("PASS");
                $display("  Outputs: J3=%h",
                         J3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: J3=%h",
                         expected_J3);
                $display("  Got:      J3=%h",
                         J3);
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
