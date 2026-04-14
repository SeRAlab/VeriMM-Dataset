`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] voltage_level;
    wire [1:0] current_frequency;
    wire frequency_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .voltage_level(voltage_level),
        .current_frequency(current_frequency),
        .frequency_signal(frequency_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        voltage_level = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power-on Reset state", test_num);
        reset_dut();

        #1;


        check_outputs(2'b00, frequency_signal);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Voltage Level 00 (Low)", test_num);
        reset_dut();
        @(posedge clk);
        voltage_level = 2'b00;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(2'b00, frequency_signal);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Voltage Level 01 (Med-Low)", test_num);
        reset_dut();
        @(posedge clk);
        voltage_level = 2'b01;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(2'b01, frequency_signal);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Voltage Level 10 (Med-High)", test_num);
        reset_dut();
        @(posedge clk);
        voltage_level = 2'b10;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(2'b10, frequency_signal);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Voltage Level 11 (High)", test_num);
        reset_dut();
        @(posedge clk);
        voltage_level = 2'b11;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(2'b11, frequency_signal);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dynamic transition High -> Low", test_num);
        reset_dut();
        @(posedge clk);
        voltage_level = 2'b11;
        repeat(5) @(posedge clk);
        voltage_level = 2'b00;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(2'b00, frequency_signal);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rapid Voltage Switching Stability", test_num);
        reset_dut();
        @(posedge clk);
        voltage_level = 2'b01;
        repeat(2) @(posedge clk);
        voltage_level = 2'b10;
        repeat(2) @(posedge clk);
        voltage_level = 2'b11;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(2'b11, frequency_signal);
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
        input [1:0] expected_current_frequency;
        input expected_frequency_signal;
        begin
            if (expected_current_frequency === (expected_current_frequency ^ current_frequency ^ expected_current_frequency) &&
                expected_frequency_signal === (expected_frequency_signal ^ frequency_signal ^ expected_frequency_signal)) begin
                $display("PASS");
                $display("  Outputs: current_frequency=%h, frequency_signal=%b",
                         current_frequency, frequency_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_frequency=%h, frequency_signal=%b",
                         expected_current_frequency, expected_frequency_signal);
                $display("  Got:      current_frequency=%h, frequency_signal=%b",
                         current_frequency, frequency_signal);
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
        $dumpvars(0,clk, reset, voltage_level, current_frequency, frequency_signal);
    end

endmodule
