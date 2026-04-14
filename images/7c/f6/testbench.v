`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] nonceF;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nonceF(nonceF),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            nonceF = 16'h0000;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic load nonce (reset low)", test_num);
            reset_dut();

            nonceF = 16'hA5A5;
            reset = 0;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain state (reset high)", test_num);
            reset_dut();


            nonceF = 16'h1234;
            reset = 0;
            @(negedge clk);
            #2;


            reset = 1;
            nonceF = 16'h5678;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge sensitivity check", test_num);
            reset_dut();


            nonceF = 16'hFEED;
            reset = 0;

            @(posedge clk);
            #1;


            @(negedge clk);
            #2;
            #1;

            check_outputs(16'hFEED);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge cases (0xFFFF and 0x0000)", test_num);
            reset_dut();


            nonceF = 16'hFFFF;
            reset = 0;
            @(negedge clk);
            #2;


            nonceF = 16'h0000;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input change between edges", test_num);
            reset_dut();

            reset = 0;
            nonceF = 16'h1111;
            @(negedge clk);
            #2;


            nonceF = 16'h2222;
            #3;


            @(negedge clk);
            #2;
            #1;

            check_outputs(16'h2222);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, nonceF, reset, out);
    end

endmodule
