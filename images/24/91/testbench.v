`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] raw_temperature;
    reg reset;
    wire [9:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .clk(clk),
        .raw_temperature(raw_temperature),
        .reset(reset),
        .calibrated_temperature(calibrated_temperature)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            raw_temperature = 10'd0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic calibration - Input 25", test_num);
            reset_dut();
            raw_temperature = 10'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum input - Input 0", test_num);
            reset_dut();
            raw_temperature = 10'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High temperature - Input 500", test_num);
            reset_dut();
            raw_temperature = 10'd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd505);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Edge case - Input 1018", test_num);
            reset_dut();
            raw_temperature = 10'd1018;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow case - Input 1023", test_num);
            reset_dut();
            raw_temperature = 10'd1023;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset priority - Reset active with input", test_num);
            reset_dut();
            raw_temperature = 10'd100;
            reset = 1;
            @(posedge clk);
            #1;
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
        $display("thermal_sensor_calibration Testbench");
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
        input [9:0] expected_calibrated_temperature;
        begin
            if (expected_calibrated_temperature === (expected_calibrated_temperature ^ calibrated_temperature ^ expected_calibrated_temperature)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temperature=%h",
                         calibrated_temperature);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temperature=%h",
                         expected_calibrated_temperature);
                $display("  Got:      calibrated_temperature=%h",
                         calibrated_temperature);
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
        $dumpvars(0,clk, raw_temperature, reset, calibrated_temperature);
    end

endmodule
