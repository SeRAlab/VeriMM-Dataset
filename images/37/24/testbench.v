`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] echo_ref;
    reg [7:0] gain;
    reg reset;
    reg [7:0] signal_in;
    wire [7:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .echo_ref(echo_ref),
        .gain(gain),
        .reset(reset),
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
        reset = 1;
        signal_in = 0;
        echo_ref = 0;
        gain = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Gain Pass-through", test_num);
        reset_dut();

        signal_in = 8'hA5;
        echo_ref = 8'hFF;
        gain = 8'h00;


        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Unit Gain Cancellation", test_num);
        reset_dut();


        echo_ref = 8'h10;
        signal_in = 8'h50;
        gain = 8'h01;
        @(posedge clk);



        #1;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Gain Scaling (Gain = 2)", test_num);
        reset_dut();

        echo_ref = 8'h20;
        gain = 8'h02;
        signal_in = 8'h70;

        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Perfect Cancellation", test_num);
        reset_dut();

        echo_ref = 8'h04;
        gain = 8'h10;
        signal_in = 8'h40;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Underflow Handling", test_num);
        reset_dut();

        echo_ref = 8'h10;
        gain = 8'h02;
        signal_in = 8'h05;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hE5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Output during Reset", test_num);

        reset = 1;
        signal_in = 8'hFF;
        echo_ref = 8'hFF;
        gain = 8'hFF;

        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00);
        reset = 0;
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
        $dumpvars(0,clk, echo_ref, gain, reset, signal_in, signal_out);
    end

endmodule
