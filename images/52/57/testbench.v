`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .rst(rst),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Active", test_num);
            rst = 1;
            in = 4'b1111;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reset Deactivation and Pattern 1111", test_num);
            rst = 1; #5;
            rst = 0; in = 4'b1111;
            #10;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Input Pattern 1010", test_num);
            rst = 1; #5;
            rst = 0; in = 4'b1010;
            #10;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Input Pattern 0101", test_num);
            rst = 1; #5;
            rst = 0; in = 4'b0101;
            #10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Input Pattern 0011", test_num);
            rst = 1; #5;
            rst = 0; in = 4'b0011;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Input Transition 1100 to 0111", test_num);
            rst = 1; #5;
            rst = 0; in = 4'b1100; #5;
            in = 4'b0111;
            #10;
            #1;

            check_outputs(4'b0100);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
