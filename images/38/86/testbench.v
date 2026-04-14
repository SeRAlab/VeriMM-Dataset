`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] offset;
    reg [7:0] raw_temp;
    reg reset;
    wire [7:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .clk(clk),
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
            raw_temp = 0;
            offset = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic calibration (25 + 10)", test_num);
            reset_dut();
            raw_temp = 8'd25;
            offset = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero offset (50 + 0)", test_num);
            reset_dut();
            raw_temp = 8'd50;
            offset = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero raw temperature (0 + 15)", test_num);
            reset_dut();
            raw_temp = 8'd0;
            offset = 8'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow check (255 + 1)", test_num);
            reset_dut();
            raw_temp = 8'd255;
            offset = 8'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values (100 + 150)", test_num);
            reset_dut();
            raw_temp = 8'd100;
            offset = 8'd150;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd250);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Stability check (Continuous update)", test_num);
            reset_dut();
            raw_temp = 8'd40;
            offset = 8'd20;
            @(posedge clk);
            #1;

            raw_temp = 8'd60;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All bits set (255 + 255)", test_num);
            reset_dut();
            raw_temp = 8'hFF;
            offset = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_calibrated_temp;
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
        $dumpvars(0,clk, offset, raw_temp, reset, calibrated_temp);
    end

endmodule
