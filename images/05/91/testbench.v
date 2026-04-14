`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] calibration_factor;
    reg clk;
    reg [11:0] raw_temp;
    reg reset;
    reg start;
    wire [11:0] calibrated_temp;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .raw_temp(raw_temp),
        .reset(reset),
        .start(start),
        .calibrated_temp(calibrated_temp),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            raw_temp = 0;
            calibration_factor = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Basic calibration", test_num);
            raw_temp = 12'h200;
            calibration_factor = 12'h020;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);
            #1;

            check_outputs(12'h220, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Zero offset calibration", test_num);
            raw_temp = 12'h500;
            calibration_factor = 12'h000;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(12'h500, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Zero raw input", test_num);
            raw_temp = 12'h000;
            calibration_factor = 12'h015;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(12'h015, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Maximum range calibration (No overflow)", test_num);
            raw_temp = 12'hFFF - 12'h005;
            calibration_factor = 12'h005;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(12'hFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Calibration with overflow (Wrap-around)", test_num);
            raw_temp = 12'hFFF;
            calibration_factor = 12'h002;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(12'h001, 1'b1);
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
        input expected_done;
        begin
            if (expected_calibrated_temp === (expected_calibrated_temp ^ calibrated_temp ^ expected_calibrated_temp) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temp=%h, done=%b",
                         calibrated_temp, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temp=%h, done=%b",
                         expected_calibrated_temp, expected_done);
                $display("  Got:      calibrated_temp=%h, done=%b",
                         calibrated_temp, done);
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
        $dumpvars(0,calibration_factor, clk, raw_temp, reset, start, calibrated_temp, done);
    end

endmodule
