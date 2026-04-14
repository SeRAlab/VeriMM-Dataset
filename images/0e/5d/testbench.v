`timescale 1ns/1ps

module temperature_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    reg [7:0] threshold;
    wire alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .threshold(threshold),
        .alarm(alarm)
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
            threshold = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Initial state check", test_num);

            temperature = 8'd0;
            threshold = 8'd100;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Temp below threshold", test_num);
            temperature = 8'd25;
            threshold = 8'd50;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Temp equal to threshold", test_num);
            temperature = 8'd50;
            threshold = 8'd50;
            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Temp above threshold (Alarm)", test_num);
            temperature = 8'd75;
            threshold = 8'd50;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Dynamic threshold change", test_num);
            temperature = 8'd40;
            threshold = 8'd60;
            @(posedge clk);
            threshold = 8'd30;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alarm cleared by reset", test_num);
            temperature = 8'd100;
            threshold = 8'd50;
            @(posedge clk);
            reset = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Maximum value limits", test_num);
            temperature = 8'hFF;
            threshold = 8'hFE;
            repeat(2) @(posedge clk);
            #1 #1;
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
        input expected_alarm;
        begin
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: alarm=%b",
                         alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%b",
                         expected_alarm);
                $display("  Got:      alarm=%b",
                         alarm);
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
        $dumpvars(0,clk, reset, temperature, threshold, alarm);
    end

endmodule
