`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] cal_factor;
    reg clk;
    reg [11:0] raw_temp;
    reg reset;
    wire [11:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .cal_factor(cal_factor),
        .clk(clk),
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
            raw_temp = 0;
            cal_factor = 0;
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
            $display("\nTest Case %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Simple Addition Calibration", test_num);
            reset_dut();
            raw_temp = 12'h100;
            cal_factor = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h105);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Zero Calibration Factor", test_num);
            reset_dut();
            raw_temp = 12'hABC;
            cal_factor = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Maximum Calibration Factor", test_num);
            reset_dut();
            raw_temp = 12'h010;
            cal_factor = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h01F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Raw Temperature at Zero", test_num);
            reset_dut();
            raw_temp = 12'h000;
            cal_factor = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h00A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: 12-bit Overflow/Wrap-around", test_num);
            reset_dut();
            raw_temp = 12'hFFF;
            cal_factor = 4'h1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Sequential Value Updates", test_num);
            reset_dut();


            raw_temp = 12'h200;
            cal_factor = 4'h2;
            @(posedge clk);
            #1;


            raw_temp = 12'h300;
            cal_factor = 4'h3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h303);
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
        input [11:0] expected_calibrated_temp;
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
        $dumpvars(0,cal_factor, clk, raw_temp, reset, calibrated_temp);
    end

endmodule
