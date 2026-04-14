`timescale 1ns/1ps

module temperature_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] temperature;
    wire above_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .above_threshold(above_threshold)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 0;
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
            $display("Running Test Case %0d: Temp=5 (Below Threshold)...", test_num);
            reset_dut();
            temperature = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Temp=13 (Above Threshold)...", test_num);
            reset_dut();
            temperature = 4'd13;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Temp=10 (Boundary Condition)...", test_num);
            reset_dut();
            temperature = 4'd10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Temp=15 (Maximum Input)...", test_num);
            reset_dut();
            temperature = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Temp=0 (Minimum Input)...", test_num);
            reset_dut();
            temperature = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Temp=12 (Sequential Stability)...", test_num);
            reset_dut();
            temperature = 4'd12;
            @(posedge clk);
            #2;
            temperature = 4'd2;
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor_controller Testbench");
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
        input expected_above_threshold;
        begin
            if (expected_above_threshold === (expected_above_threshold ^ above_threshold ^ expected_above_threshold)) begin
                $display("PASS");
                $display("  Outputs: above_threshold=%b",
                         above_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: above_threshold=%b",
                         expected_above_threshold);
                $display("  Got:      above_threshold=%b",
                         above_threshold);
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
        $dumpvars(0,clk, reset, temperature, above_threshold);
    end

endmodule
