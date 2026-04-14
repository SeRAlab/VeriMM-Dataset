`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] inp;
    wire [15:0] arr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inp(inp),
        .arr_out(arr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            inp = 4'h0;

            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Verification of cleared register");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Shifting in single nibble 4'hA");
            inp = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Filling register with 1, 2, 3, 4");
            inp = 4'h1; @(posedge clk);
            inp = 4'h2; @(posedge clk);
            inp = 4'h3; @(posedge clk);
            inp = 4'h4; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Shifting 5 nibbles (F, E, D, C, B) - first nibble should drop");
            inp = 4'hF; @(posedge clk);
            inp = 4'hE; @(posedge clk);
            inp = 4'hD; @(posedge clk);
            inp = 4'hC; @(posedge clk);
            inp = 4'hB; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Alternating pattern A5A5");
            inp = 4'hA; @(posedge clk);
            inp = 4'h5; @(posedge clk);
            inp = 4'hA; @(posedge clk);
            inp = 4'h5; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Shifting in all ones (FFFF)");
            inp = 4'hF; @(posedge clk);
            inp = 4'hF; @(posedge clk);
            inp = 4'hF; @(posedge clk);
            inp = 4'hF; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_arr_out;
        begin
            if (expected_arr_out === (expected_arr_out ^ arr_out ^ expected_arr_out)) begin
                $display("PASS");
                $display("  Outputs: arr_out=%h",
                         arr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arr_out=%h",
                         expected_arr_out);
                $display("  Got:      arr_out=%h",
                         arr_out);
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
        $dumpvars(0,clk, inp, arr_out);
    end

endmodule
