`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] count;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .display(display)
    );
    task testcase000;

        begin
            test_num = 0;
            count = 3'd0;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            count = 3'd1;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            count = 3'd2;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            count = 3'd3;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            count = 3'd4;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            count = 3'd5;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            count = 3'd6;
            #1;

            check_outputs(7'b1111101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            count = 3'd7;
            #1;

            check_outputs(7'b0000111);
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


        testcase000();
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
        input [6:0] expected_display;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
