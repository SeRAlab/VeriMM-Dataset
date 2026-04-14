`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg up_down;
    wire out;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .up_down(up_down),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_down = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Incrementing");
            reset_dut();
            up_down = 1;
            data_in = 4'd5;
            repeat (8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd8);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Decrementing");
            reset_dut();
            up_down = 1;
            repeat (10) @(posedge clk);
            up_down = 0;
            repeat (3) @(posedge clk);
            data_in = 4'd7;
            #1;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Underflow wrap-around");
            reset_dut();
            up_down = 0;
            repeat (1) @(posedge clk);
            data_in = 4'd14;
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overflow wrap-around");
            reset_dut();
            up_down = 1;
            repeat (16) @(posedge clk);
            data_in = 4'd0;
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Comparison with Max data_in");
            reset_dut();
            up_down = 1;
            repeat (15) @(posedge clk);
            data_in = 4'd15;
            #1;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Changing data_in while counter is stable");
            reset_dut();
            up_down = 1;
            repeat (5) @(posedge clk);
            data_in = 4'd10;
            #2;
            data_in = 4'd2;
            #1;
            #1;

            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Reset Priority over counting");
            reset_dut();
            up_down = 1;
            repeat (5) @(posedge clk);
            reset = 1;
            data_in = 4'd0;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0, 4'd0);
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
        input expected_out;
        input [3:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%h",
                         out, q);
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
        $dumpvars(0,clk, data_in, reset, up_down, out, q);
    end

endmodule
