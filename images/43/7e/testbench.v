`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d_in;
    wire [1:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_in(d_in),
        .d_out(d_out)
    );
    task testcase001;

        begin
            test_num = 1;
            d_in = 4'b0000;
            $display("Test %0d: d_in = %b (None active)", test_num, d_in);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            d_in = 4'b0001;
            $display("Test %0d: d_in = %b (Bit 0 priority)", test_num, d_in);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            d_in = 4'b0010;
            $display("Test %0d: d_in = %b (Bit 1 priority)", test_num, d_in);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            d_in = 4'b0100;
            $display("Test %0d: d_in = %b (Bit 2 priority)", test_num, d_in);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            d_in = 4'b1000;
            $display("Test %0d: d_in = %b (Bit 3 priority)", test_num, d_in);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            d_in = 4'b1001;
            $display("Test %0d: d_in = %b (Priority Conflict: 3 vs 0)", test_num, d_in);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            d_in = 4'b0110;
            $display("Test %0d: d_in = %b (Priority Conflict: 2 vs 1)", test_num, d_in);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            d_in = 4'b1111;
            $display("Test %0d: d_in = %b (All bits active)", test_num, d_in);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            d_in = 4'b0011;
            $display("Test %0d: d_in = %b (Priority Conflict: 1 vs 0)", test_num, d_in);
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_d_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
