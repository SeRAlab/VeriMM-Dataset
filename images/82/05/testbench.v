`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] bcd_in;
    reg clk;
    wire [3:0] binary_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_in(bcd_in),
        .clk(clk),
        .binary_out(binary_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bcd_in = 16'h0;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros (BCD 0000)", test_num);
            reset_dut();
            bcd_in = 16'h0000;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unit Digit (BCD 0005)", test_num);
            reset_dut();
            bcd_in = 16'h0005;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Tens Digit (BCD 0010)", test_num);
            reset_dut();
            bcd_in = 16'h0010;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max 4-bit Decimal (BCD 0015)", test_num);
            reset_dut();
            bcd_in = 16'h0015;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hundreds Digit (BCD 0100)", test_num);
            reset_dut();
            bcd_in = 16'h0100;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Thousands Digit (BCD 1000)", test_num);
            reset_dut();
            bcd_in = 16'h1000;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum BCD value (BCD 9999)", test_num);
            reset_dut();
            bcd_in = 16'h9999;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(4'hF);
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
        input [3:0] expected_binary_out;
        begin
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h",
                         binary_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h",
                         expected_binary_out);
                $display("  Got:      binary_out=%h",
                         binary_out);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,bcd_in, clk, binary_out);
    end

endmodule
