`timescale 1ns/1ps

module rnn_unit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [7:0] x_in;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_unit dut (
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            x_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Addition...");
            test_num = 1;
            reset_dut();
            x_in = 8'd5;
            @(posedge clk);
            #1;
            x_in = 8'd10;
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Sequence Accumulation...");
            test_num = 2;
            reset_dut();
            x_in = 8'd1; @(posedge clk);
            x_in = 8'd2; @(posedge clk);
            x_in = 8'd3; @(posedge clk);
            #1;
            x_in = 8'd4;
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overflow Check...");
            test_num = 3;
            reset_dut();
            x_in = 8'd200;
            @(posedge clk);
            #1;
            x_in = 8'd100;
            #1;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Zero Input Check...");
            test_num = 4;
            reset_dut();
            x_in = 8'd50; @(posedge clk);
            x_in = 8'd0;  @(posedge clk);
            #1;
            x_in = 8'd0;
            #1;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Max Wrap Check...");
            test_num = 5;
            reset_dut();
            x_in = 8'd255;
            @(posedge clk);
            #1;
            x_in = 8'd1;
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_unit Testbench");
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
        input [7:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, rst_n, x_in, y_out);
    end

endmodule
