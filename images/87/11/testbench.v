`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [15:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Ctrl 00 (Original)", test_num);
            ctrl = 2'b00;
            in = 16'hA5A5;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Ctrl 00 (All ones)", test_num);
            ctrl = 2'b00;
            in = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Ctrl 01 (Negation)", test_num);
            ctrl = 2'b01;
            in = 16'h5555;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Ctrl 01 (Negation Zeroes)", test_num);
            ctrl = 2'b01;
            in = 16'h0000;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Ctrl 10 (Left Shift)", test_num);
            ctrl = 2'b10;
            in = 16'h0001;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Ctrl 10 (Left Shift Overflow)", test_num);
            ctrl = 2'b10;
            in = 16'hC001;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Ctrl 11 (Right Shift)", test_num);
            ctrl = 2'b11;
            in = 16'h8000;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Ctrl 11 (Right Shift Zero Fill Check)", test_num);
            ctrl = 2'b11;
            in = 16'h0003;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Ctrl 11 (Right Shift Pattern)", test_num);
            ctrl = 2'b11;
            in = 16'hF0F0;
            #1;

            check_outputs(16'h3C3C);
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
        input [15:0] expected_out;
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
