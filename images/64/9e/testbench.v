`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] x;
    reg [19:0] y;
    wire [9:0] cout;
    wire s0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .cout(cout),
        .s0(s0)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 20'hFFFFF;
            y = 20'hFFFFF;
            #1;

            check_outputs(10'h3FE, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 20'hFFFFF;
            y = 20'h00000;
            #1;

            check_outputs(10'h000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 20'h80200;
            y = 20'hFFFFF;
            #1;

            check_outputs(10'h000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 20'h00401;
            y = 20'hFFFFF;
            #1;

            check_outputs(10'h002, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 20'hFFC01;
            y = 20'hFFFFF;
            #1;

            check_outputs(10'h000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 20'h12345;
            y = 20'hFFFFF;
            #1;

            check_outputs(10'h38D, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 20'hAAAAA;
            y = 20'hAAAAA;
            #1;

            check_outputs(10'h3FE, 1'b1);
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
        input [9:0] expected_cout;
        input expected_s0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s0 === (expected_s0 ^ s0 ^ expected_s0)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s0=%b",
                         cout, s0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s0=%b",
                         expected_cout, expected_s0);
                $display("  Got:      cout=%h, s0=%b",
                         cout, s0);
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
