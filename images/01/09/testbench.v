`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] temp_in;
    wire [7:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .clk(clk),
        .rst(rst),
        .temp_in(temp_in),
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
            temp_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady State Input (30, 30, 30)", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'd30;
            @(posedge clk) temp_in = 8'd30;
            @(posedge clk) temp_in = 8'd30;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linear Ramp Input (10, 20, 30)", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'd10;
            @(posedge clk) temp_in = 8'd20;
            @(posedge clk) temp_in = 8'd30;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (255, 255, 255)", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'hFF;
            @(posedge clk) temp_in = 8'hFF;
            @(posedge clk) temp_in = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Values (0, 0, 0)", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'd0;
            @(posedge clk) temp_in = 8'd0;
            @(posedge clk) temp_in = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Fluctuations (100, 0, 200)", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'd100;
            @(posedge clk) temp_in = 8'd0;
            @(posedge clk) temp_in = 8'd200;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Truncation Check (10, 11, 11)", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'd10;
            @(posedge clk) temp_in = 8'd11;
            @(posedge clk) temp_in = 8'd11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Register/Window Check", test_num);
            reset_dut();
            @(posedge clk) temp_in = 8'd100;
            @(posedge clk) temp_in = 8'd50;
            @(posedge clk) temp_in = 8'd50;
            @(posedge clk) temp_in = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd50);
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
        $dumpvars(0,clk, rst, temp_in, calibrated_temp);
    end

endmodule
