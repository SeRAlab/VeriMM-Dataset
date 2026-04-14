`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode;
    reg reset;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .mode(mode),
        .reset(reset),
        .frequency(frequency),
        .voltage(voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        mode = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verifying Default Mode 0 after Reset", test_num);
        reset_dut();

        #10;
        #1;

        check_outputs(2'd1, 2'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Transition from Mode 0 to Mode 1 (Normal Power)", test_num);
        reset_dut();
        mode = 1;
        @(posedge clk);
        #10;
        #1;

        check_outputs(2'd2, 2'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Transition from Mode 1 back to Mode 0 (Low Power)", test_num);
        reset_dut();
        mode = 1;
        @(posedge clk);
        mode = 0;
        @(posedge clk);
        #10;
        #1;

        check_outputs(2'd1, 2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verifying Reset overrides Mode 1", test_num);
        reset_dut();
        mode = 1;
        @(posedge clk);

        reset = 1;
        @(posedge clk);
        #10;
        #1;

        check_outputs(2'd1, 2'd1);
        reset = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verifying Output Stability in Mode 1", test_num);
        reset_dut();
        mode = 1;
        repeat(5) @(posedge clk);
        #10;
        #1;

        check_outputs(2'd2, 2'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [1:0] expected_frequency;
        input [1:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, mode, reset, frequency, voltage);
    end

endmodule
