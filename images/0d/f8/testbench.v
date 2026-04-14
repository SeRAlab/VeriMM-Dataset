`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] sensor1_measurement;
    reg [31:0] sensor1_uncertainty;
    reg [31:0] sensor2_measurement;
    reg [31:0] sensor2_uncertainty;
    wire [31:0] fused_measurement;
    wire [31:0] fused_uncertainty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .reset(reset),
        .sensor1_measurement(sensor1_measurement),
        .sensor1_uncertainty(sensor1_uncertainty),
        .sensor2_measurement(sensor2_measurement),
        .sensor2_uncertainty(sensor2_uncertainty),
        .fused_measurement(fused_measurement),
        .fused_uncertainty(fused_uncertainty)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sensor1_measurement = 0;
            sensor1_uncertainty = 0;
            sensor2_measurement = 0;
            sensor2_uncertainty = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equal uncertainty (Weighted Average)", test_num);
            reset_dut();
            sensor1_measurement = 32'd100;
            sensor1_uncertainty = 32'd10;
            sensor2_measurement = 32'd200;
            sensor2_uncertainty = 32'd10;


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd150, 32'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sensor 1 more certain", test_num);
            reset_dut();
            sensor1_measurement = 32'd100;
            sensor1_uncertainty = 32'd10;
            sensor2_measurement = 32'd200;
            sensor2_uncertainty = 32'd90;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd110, 32'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sensor 2 more certain", test_num);
            reset_dut();
            sensor1_measurement = 32'd100;
            sensor1_uncertainty = 32'd90;
            sensor2_measurement = 32'd200;
            sensor2_uncertainty = 32'd10;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd190, 32'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identical measurements", test_num);
            reset_dut();
            sensor1_measurement = 32'd500;
            sensor1_uncertainty = 32'd20;
            sensor2_measurement = 32'd500;
            sensor2_uncertainty = 32'd30;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd500, 32'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Larger values", test_num);
            reset_dut();
            sensor1_measurement = 32'd1000;
            sensor1_uncertainty = 32'd500;
            sensor2_measurement = 32'd2000;
            sensor2_uncertainty = 32'd500;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd1500, 32'd250);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integer truncation check", test_num);
            reset_dut();
            sensor1_measurement = 32'd10;
            sensor1_uncertainty = 32'd3;
            sensor2_measurement = 32'd20;
            sensor2_uncertainty = 32'd4;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd14, 32'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [31:0] expected_fused_measurement;
        input [31:0] expected_fused_uncertainty;
        begin
            if (expected_fused_measurement === (expected_fused_measurement ^ fused_measurement ^ expected_fused_measurement) &&
                expected_fused_uncertainty === (expected_fused_uncertainty ^ fused_uncertainty ^ expected_fused_uncertainty)) begin
                $display("PASS");
                $display("  Outputs: fused_measurement=%h, fused_uncertainty=%h",
                         fused_measurement, fused_uncertainty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fused_measurement=%h, fused_uncertainty=%h",
                         expected_fused_measurement, expected_fused_uncertainty);
                $display("  Got:      fused_measurement=%h, fused_uncertainty=%h",
                         fused_measurement, fused_uncertainty);
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
        $dumpvars(0,clk, reset, sensor1_measurement, sensor1_uncertainty, sensor2_measurement, sensor2_uncertainty, fused_measurement, fused_uncertainty);
    end

endmodule
