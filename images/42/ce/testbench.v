`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] counter_out;
    reg in;
    reg reset;
    wire out;
    wire [3:0] q;
    wire [3:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .counter_out(counter_out),
        .in(in),
        .reset(reset),
        .out(out),
        .q(q),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            counter_out = 0;
            @(posedge clk);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Reset State Verification", test_num);
            reset_dut();
            in = 0;
            counter_out = 4'h5;
            #1;

            #1;


            check_outputs(1'b0, 4'h0, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Increment and Count Selection (in=0)", test_num);
            reset_dut();
            @(posedge clk);
            in = 0;
            counter_out = 4'h2;
            #1;

            #1;


            check_outputs(1'b0, 4'h1, 4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 2's Complement Selection (in=1)", test_num);
            reset_dut();
            @(posedge clk);
            in = 1;
            counter_out = 4'h2;
            #1;


            #1;



            check_outputs(1'b1, 4'h1, 4'h1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Counter Wrap-around", test_num);
            reset_dut();
            for(i=0; i<15; i=i+1) @(posedge clk);
            in = 0;
            counter_out = 4'h1;
            #1;

            #1;


            check_outputs(1'b0, 4'hF, 4'h0);

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0, 4'h1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 2's Complement Edge Case (Q=8)", test_num);
            reset_dut();
            for(i=0; i<8; i=i+1) @(posedge clk);
            in = 1;
            counter_out = 4'h2;
            #1;

            #1;


            check_outputs(1'b1, 4'h8, 4'hA);
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
        input expected_out;
        input [3:0] expected_q;
        input [3:0] expected_sum_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h, sum_out=%h",
                         out, q, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h, sum_out=%h",
                         expected_out, expected_q, expected_sum_out);
                $display("  Got:      out=%b, q=%h, sum_out=%h",
                         out, q, sum_out);
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
        $dumpvars(0,clk, counter_out, in, reset, out, q, sum_out);
    end

endmodule
