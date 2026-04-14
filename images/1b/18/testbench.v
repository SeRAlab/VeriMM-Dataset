`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        x = 0;
        d = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Zero Input Stability", test_num);
        reset_dut();
        x = 16'h0000;
        d = 16'h0000;
        repeat(50) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Positive DC Convergence", test_num);
        reset_dut();

        x = 16'h0010;
        d = 16'h0010;

        repeat(200) @(posedge clk);
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Scaling Adaptation (Gain of 2)", test_num);
        reset_dut();
        x = 16'h0020;
        d = 16'h0040;
        repeat(300) @(posedge clk);
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Negative Convergence", test_num);
        reset_dut();

        x = 16'hFFF0;
        d = 16'hFFF0;
        repeat(200) @(posedge clk);
        #1;

        check_outputs(16'hFFF0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Adaptation to Zero", test_num);
        reset_dut();

        x = 16'h00FF; d = 16'h00FF;
        repeat(100) @(posedge clk);

        d = 16'h0000;
        repeat(200) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, d, reset, x, y);
    end

endmodule
