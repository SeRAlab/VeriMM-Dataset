`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] cal_factor;
    reg clk;
    reg [9:0] raw_temp;
    reg rst;
    wire [9:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .cal_factor(cal_factor),
        .clk(clk),
        .raw_temp(raw_temp),
        .rst(rst),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            raw_temp = 0;
            cal_factor = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Inputs", test_num);
            reset_dut();
            raw_temp = 10'd0;
            cal_factor = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: No Calibration (Factor 0)", test_num);
            reset_dut();
            raw_temp = 10'd512;
            cal_factor = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd512);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Power of 2 Scaling", test_num);
            reset_dut();
            raw_temp = 10'd256;
            cal_factor = 4'd8;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd384);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Truncation Check", test_num);
            reset_dut();
            raw_temp = 10'd15;
            cal_factor = 4'd1;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Max Calibration Adjustment", test_num);
            reset_dut();
            raw_temp = 10'd64;
            cal_factor = 4'd15;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd124);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Max Raw Value No Factor", test_num);
            reset_dut();
            raw_temp = 10'd1023;
            cal_factor = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd1023);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow Wrap-around Test", test_num);
            reset_dut();
            raw_temp = 10'd1023;
            cal_factor = 4'd15;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd958);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Prime-like Values", test_num);
            reset_dut();
            raw_temp = 10'd333;
            cal_factor = 4'd7;
            @(posedge clk);
            #2 #1;
 check_outputs(10'd478);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibration Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,cal_factor, clk, raw_temp, rst, calibrated_temp);
    end

endmodule
