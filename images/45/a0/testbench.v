`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [15:0] xor_key;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .xor_key(xor_key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 16'h0;
            xor_key = 16'h0;

            repeat(4) @(posedge clk);
        end
        endtask
    task testcase001;

        reg [15:0] expected;
        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 16'hAAAA;
            xor_key = 16'h5555;
            expected = data_in ^ xor_key;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case %03d: Basic XOR (AAAA ^ 5555)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase002;

        reg [15:0] expected;
        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 16'h1234;
            xor_key = 16'h0000;
            expected = 16'h1234;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case %03d: Identity XOR (1234 ^ 0000)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [15:0] expected;
        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 16'hBEEF;
            xor_key = 16'hBEEF;
            expected = 16'h0000;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case %03d: Self XOR (BEEF ^ BEEF)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [15:0] expected;
        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 16'h0F0F;
            xor_key = 16'hFFFF;
            expected = ~16'h0F0F;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case %03d: Inversion XOR (0F0F ^ FFFF)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [15:0] expected;
        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 16'hFFFF;
            xor_key = 16'hFFFF;
            expected = 16'h0000;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case %03d: Max Value XOR (FFFF ^ FFFF)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase006;

        reg [15:0] expected;
        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 16'hABCD;
            xor_key = 16'h1357;
            expected = 16'hABCD ^ 16'h1357;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case %03d: Random Pattern (ABCD ^ 1357)", test_num);
            #1;

            check_outputs(expected);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, xor_key, data_out);
    end

endmodule
