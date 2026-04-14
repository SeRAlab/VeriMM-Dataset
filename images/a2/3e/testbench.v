`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] exponent_in;
    reg [8:0] val1;
    reg [8:0] val2;
    wire [7:0] exponent_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exponent_in(exponent_in),
        .val1(val1),
        .val2(val2),
        .exponent_out(exponent_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction", test_num);
            exponent_in = 8'h64;
            val1 = 9'h000;
            val2 = 9'h00A;
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            exponent_in = 8'h64;
            val1 = 9'h000;
            val2 = 9'h10A;
            #1;
            #1;

            check_outputs(8'h6E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtract to Zero", test_num);
            exponent_in = 8'hFF;
            val1 = 9'h000;
            val2 = 9'h0FF;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow Wrap-around", test_num);
            exponent_in = 8'h05;
            val1 = 9'h000;
            val2 = 9'h00A;
            #1;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Wrap-around", test_num);
            exponent_in = 8'hF0;
            val1 = 9'h000;
            val2 = 9'h120;
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max val2 Addition", test_num);
            exponent_in = 8'h01;
            val1 = 9'h000;
            val2 = 9'h1FF;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify val1 is ignored", test_num);
            exponent_in = 8'h80;
            val1 = 9'h1FF;
            val2 = 9'h101;
            #1;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Offset Subtraction", test_num);
            exponent_in = 8'hAA;
            val1 = 9'h000;
            val2 = 9'h000;
            #1;
            #1;

            check_outputs(8'hAA);
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
        input [7:0] expected_exponent_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exponent_out === (expected_exponent_out ^ exponent_out ^ expected_exponent_out)) begin
                $display("PASS");
                $display("  Outputs: exponent_out=%h",
                         exponent_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exponent_out=%h",
                         expected_exponent_out);
                $display("  Got:      exponent_out=%h",
                         exponent_out);
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
