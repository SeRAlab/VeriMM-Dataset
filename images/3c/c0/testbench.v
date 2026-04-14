`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
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
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Zero Input", test_num);
        reset_dut();
        x = 16'sd0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Impulse Response (t=0)", test_num);
        reset_dut();
        x = 16'sd100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(COEF_B0 * 16'sd100);
    end
        endtask

    task testcase003;

    reg signed [15:0] y0, y1;
    begin
        test_num = 3;
        $display("\nTestcase %03d: Multi-step Calculation", test_num);
        reset_dut();


        x = 16'sd10;
        y0 = COEF_B0 * 16'sd10;
        @(posedge clk);


        x = 16'sd0;
        y1 = (COEF_B1 * 16'sd10) + (COEF_A1 * y0);
        @(posedge clk);

        #1;
        #1;

        check_outputs(y1);
    end
        endtask

    task testcase004;

    reg signed [15:0] expected;
    begin
        test_num = 4;
        $display("\nTestcase %03d: Signed/Negative Input", test_num);
        reset_dut();


        x = -16'sd50;
        expected = COEF_B0 * -16'sd50;
        @(posedge clk);
        #1;
        #1;

        check_outputs(expected);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Reset Mid-Operation", test_num);
        reset_dut();

        x = 16'sd1000;
        repeat(3) @(posedge clk);

        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'sd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        $dumpvars(0,clk, reset, x, y);
    end

endmodule
