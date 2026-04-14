`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] urng_seed1;
    reg [31:0] urng_seed2;
    reg [31:0] urng_seed3;
    wire [31:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .urng_seed1(urng_seed1),
        .urng_seed2(urng_seed2),
        .urng_seed3(urng_seed3),
        .out(out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            urng_seed1 = 32'h0;
            urng_seed2 = 32'h0;
            urng_seed3 = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State...", test_num);
            reset = 1;
            #15;
            #1;

            check_outputs(32'h0, 1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Generation (Valid signal check)...", test_num);
            reset_dut();
            urng_seed1 = 32'hACE1;
            urng_seed2 = 32'hBEEF;
            urng_seed3 = 32'hCAFE;


            repeat(2) @(posedge clk);
            #1;


            if (valid === 1'b1 && out !== 32'h0) begin
                $display("PASS: Random number generated.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: No valid output or output is zero.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying sequence changes over time...", test_num);
            reset_dut();
            urng_seed1 = 32'h12345678;
            urng_seed2 = 32'h87654321;
            urng_seed3 = 32'h55AA55AA;

            @(posedge clk);
            #1;
            last_val = out;

            @(posedge clk);
            #1;
            if (out != last_val && valid === 1'b1) begin
                $display("PASS: Output changed from %h to %h", last_val, out);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Output stuck at %h", out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [31:0] out_a;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying seed sensitivity...", test_num);


            reset_dut();
            urng_seed1 = 32'hAAAAAAAA;
            urng_seed2 = 32'hBBBBBBBB;
            urng_seed3 = 32'hCCCCCCCC;
            @(posedge clk);
            #1 out_a = out;


            reset_dut();
            urng_seed1 = 32'h11111111;
            urng_seed2 = 32'h22222222;
            urng_seed3 = 32'h33333333;
            @(posedge clk);
            #1;

            if (out != out_a) begin
                $display("PASS: Different seeds produced different outputs (%h vs %h)", out_a, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Different seeds produced same output.");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_out;
        input expected_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
        $dumpvars(0,clk, reset, urng_seed1, urng_seed2, urng_seed3, out, valid);
    end

endmodule
