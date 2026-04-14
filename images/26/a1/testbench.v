`timescale 1ns/1ps

module ThermalSensorCalibrator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] raw_temp;
    reg reset;
    wire [4:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ThermalSensorCalibrator dut (
        .clk(clk),
        .enable(enable),
        .raw_temp(raw_temp),
        .reset(reset),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        raw_temp = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Scaling Raw Temp 5 (Enable=1)", test_num);
        reset_dut();
        raw_temp = 4'd5;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Scaling Max Raw Temp 15 (Enable=1)", test_num);
        reset_dut();
        raw_temp = 4'd15;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying Enable=0 prevents update", test_num);
        reset_dut();


        raw_temp = 4'd3;
        enable = 1;
        @(posedge clk);
        #1;


        raw_temp = 4'd10;
        enable = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(5'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Scaling Min Raw Temp 0 (Enable=1)", test_num);
        reset_dut();


        raw_temp = 4'd8;
        enable = 1;
        @(posedge clk);
        #1;


        raw_temp = 4'd0;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Back-to-back updates", test_num);
        reset_dut();

        enable = 1;
        raw_temp = 4'd2;
        @(posedge clk);
        #1;

        raw_temp = 4'd7;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'd14);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ThermalSensorCalibrator Testbench");
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
        input [4:0] expected_calibrated_temp;
        begin
            if (expected_calibrated_temp === (expected_calibrated_temp ^ calibrated_temp ^ expected_calibrated_temp)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temp=%h",
                         calibrated_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temp=%h",
                         expected_calibrated_temp);
                $display("  Got:      calibrated_temp=%h",
                         calibrated_temp);
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
        $dumpvars(0,clk, enable, raw_temp, reset, calibrated_temp);
    end

endmodule
