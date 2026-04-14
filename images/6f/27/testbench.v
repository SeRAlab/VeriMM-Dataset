`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [39:0] a;
    reg add_sub;
    reg adder_en;
    reg [39:0] b;
    wire [39:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .add_sub(add_sub),
        .adder_en(adder_en),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition (5 + 10)");
            a = 40'h0000000005;
            b = 40'h000000000A;
            add_sub = 1'b0;
            adder_en = 1'b1;
            #1;

            check_outputs(40'h000000000F);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Subtraction (20 - 5)");
            a = 40'h0000000005;
            b = 40'h0000000014;
            add_sub = 1'b1;
            adder_en = 1'b1;
            #1;

            check_outputs(40'h000000000F);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition Overflow (Max + 1)");
            a = 40'hFFFFFFFFFF;
            b = 40'h0000000001;
            add_sub = 1'b0;
            adder_en = 1'b1;
            #1;

            check_outputs(40'h0000000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction Negative Result (5 - 10)");
            a = 40'h000000000A;
            b = 40'h0000000005;
            add_sub = 1'b1;
            adder_en = 1'b1;

            #1;


            check_outputs(40'hFFFFFFFFFB);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Large Numbers Addition");
            a = 40'h123456789A;
            b = 40'h8765432105;
            add_sub = 1'b0;
            adder_en = 1'b1;
            #1;

            check_outputs(40'h999999999F);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction (a = b)");
            a = 40'hABCDE12345;
            b = 40'hABCDE12345;
            add_sub = 1'b1;
            adder_en = 1'b1;
            #1;

            check_outputs(40'h0000000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Adder Disabled (adder_en = 0)");
            a = 40'h0000000005;
            b = 40'h000000000A;
            add_sub = 1'b0;
            adder_en = 1'b0;


            #1;



            check_outputs(40'h0000000000);
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
        input [39:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
