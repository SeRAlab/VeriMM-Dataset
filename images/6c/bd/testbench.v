`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] c;
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
            test_num = 1;
            c = 4'd0;
            $display("Test Case %0d: Input = 0", test_num);
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            c = 4'd1;
            $display("Test Case %0d: Input = 1", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            c = 4'd2;
            $display("Test Case %0d: Input = 2", test_num);
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            c = 4'd3;
            $display("Test Case %0d: Input = 3", test_num);
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            c = 4'd4;
            $display("Test Case %0d: Input = 4", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            c = 4'd5;
            $display("Test Case %0d: Input = 5", test_num);
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            c = 4'd6;
            $display("Test Case %0d: Input = 6", test_num);
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            c = 4'd7;
            $display("Test Case %0d: Input = 7", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            c = 4'd8;
            $display("Test Case %0d: Input = 8", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            c = 4'd9;
            $display("Test Case %0d: Input = 9", test_num);
            #1;

            check_outputs(7'h6F);
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
