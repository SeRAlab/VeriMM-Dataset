`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] load;
    reg rst;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .load(load),
        .rst(rst),
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
        $display("\nResetting DUT...");
        rst = 1;
        load = 2'b00;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Low Load (00)", test_num);
        reset_dut();
        load = 2'b00;
        @(posedge clk);
        #2 #1;
 check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Medium Load (01)", test_num);
        reset_dut();
        load = 2'b01;
        @(posedge clk);
        #2 #1;
 check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High Load (10)", test_num);
        reset_dut();
        load = 2'b10;
        @(posedge clk);
        #2 #1;
 check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Load (11) - Hold Last State (Medium)", test_num);
        reset_dut();

        load = 2'b01;
        @(posedge clk);

        load = 2'b11;
        @(posedge clk);
        #2 #1;
 check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Load (11) - Hold Last State (High)", test_num);
        reset_dut();

        load = 2'b10;
        @(posedge clk);

        load = 2'b11;
        @(posedge clk);
        #2 #1;
 check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiple Transitions (High -> Low)", test_num);
        reset_dut();
        load = 2'b10;
        @(posedge clk);
        load = 2'b00;
        @(posedge clk);
        #2 #1;
 check_outputs(2'b01, 2'b01);
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
        $dumpvars(0,clk, load, rst, frequency, voltage);
    end

endmodule
