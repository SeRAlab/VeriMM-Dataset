`timescale 1ns/1ps

module ThermalSensorCalibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [5:0] offset;
    reg [9:0] raw_temp;
    reg reset;
    wire [9:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ThermalSensorCalibration dut (
        .clk(clk),
        .enable(enable),
        .offset(offset),
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
            offset = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic calibration (Positive Offset)", test_num);
            reset_dut();

            raw_temp = 10'd200;
            offset = 6'd15;
            enable = 1;

            @(posedge clk);
            enable = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(10'd215);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Zero Offset", test_num);
            reset_dut();

            raw_temp = 10'd512;
            offset = 6'd0;
            enable = 1;

            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(10'd512);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Max Raw Temp", test_num);
            reset_dut();

            raw_temp = 10'd1023;
            offset = 6'd5;
            enable = 1;

            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(10'd1023 + 6'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: System Disabled (Enable=0)", test_num);
            reset_dut();


            raw_temp = 10'd300;
            offset = 6'd20;
            enable = 0;

            repeat(3) @(posedge clk);


            #1;



            check_outputs(10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset during processing", test_num);
            reset_dut();

            raw_temp = 10'd450;
            offset = 6'd10;
            enable = 1;

            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(10'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ThermalSensorCalibration Testbench");
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
        input [9:0] expected_calibrated_temp;
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
        $dumpvars(0,clk, enable, offset, raw_temp, reset, calibrated_temp);
    end

endmodule
