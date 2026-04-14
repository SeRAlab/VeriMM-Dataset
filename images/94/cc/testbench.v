`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .display(display)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input c = 0", test_num);
            c = 1'b0;


            #1;



            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input c = 1", test_num);
            c = 1'b1;


            #1;



            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle back to Input c = 0", test_num);
            c = 1'b0;
            #1;

            check_outputs(7'b0111111);
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
