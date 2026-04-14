`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] delayed_signal;
    reg rst_n;
    reg [7:0] signal_in;
    wire [7:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .delayed_signal(delayed_signal),
        .rst_n(rst_n),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            signal_in = 0;
            delayed_signal = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Subtraction (20 - 5)", test_num);
            reset_dut();
            signal_in = 8'd20;
            delayed_signal = 8'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Cancellation (100 - 100)", test_num);
            reset_dut();
            signal_in = 8'd100;
            delayed_signal = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap-around Subtraction (10 - 30)", test_num);
            reset_dut();
            signal_in = 8'd10;
            delayed_signal = 8'd30;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Value and Zero Delay (255 - 0)", test_num);
            reset_dut();
            signal_in = 8'hFF;
            delayed_signal = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max-Max subtraction (255 - 255)", test_num);
            reset_dut();
            signal_in = 8'hFF;
            delayed_signal = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single bit difference (1 - 0)", test_num);
            reset_dut();
            signal_in = 8'd1;
            delayed_signal = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Steady state check after sequence", test_num);
            reset_dut();

            signal_in = 8'd50; delayed_signal = 8'd10; @(posedge clk);
            signal_in = 8'd60; delayed_signal = 8'd20; @(posedge clk);
            signal_in = 8'd70; delayed_signal = 8'd30; @(posedge clk);
            #1;

            #1;


            check_outputs(8'd40);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        input [7:0] expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
        $dumpvars(0,clk, delayed_signal, rst_n, signal_in, signal_out);
    end

endmodule
