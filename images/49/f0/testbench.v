`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg rst;
    wire [3:0] out;
    wire [2:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .out(out),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 3'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Single Transition - Input pattern 4'h1", test_num);
            reset_dut();
            in = 4'h1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h1, 3'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Multi-step Sequential Transitions", test_num);
            reset_dut();

            in = 4'h1; @(posedge clk);
            #1 in = 4'h2; @(posedge clk);
            #1 in = 4'h4; @(posedge clk);

            #2;

            #1;


            check_outputs(4'h7, 3'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Maximum Input Value Transition", test_num);
            reset_dut();
            in = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 3'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset Triggered Mid-Operation", test_num);
            reset_dut();

            in = 4'hA; @(posedge clk);
            in = 4'h5; @(posedge clk);


            rst = 1;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(4'h0, 3'h0);
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
        input [3:0] expected_out;
        input [2:0] expected_state;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: out=%h, state=%h",
                         out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, state=%h",
                         expected_out, expected_state);
                $display("  Got:      out=%h, state=%h",
                         out, state);
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
        $dumpvars(0,clk, in, rst, out, state);
    end

endmodule
