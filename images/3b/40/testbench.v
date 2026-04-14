`timescale 1ns/1ps

module TemperatureSensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    reg [7:0] threshold;
    wire alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TemperatureSensor dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .threshold(threshold),
        .alert(alert)
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
            threshold = 8'hFF;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Temperature below threshold", test_num);
            reset_dut();
            temperature = 8'd25;
            threshold = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Temperature strictly above threshold", test_num);
            reset_dut();
            temperature = 8'd75;
            threshold = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Temperature exactly equal to threshold (should not trigger)", test_num);
            reset_dut();
            temperature = 8'd50;
            threshold = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Maximum temperature and threshold boundary", test_num);
            reset_dut();
            temperature = 8'hFF;
            threshold = 8'hFE;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Minimum values (0 vs 0)", test_num);
            reset_dut();
            temperature = 8'h00;
            threshold = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset functionality during alert state", test_num);
            reset_dut();

            temperature = 8'd100;
            threshold = 8'd50;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Recovery from alert state", test_num);
            reset_dut();

            temperature = 8'd100;
            threshold = 8'd50;
            @(posedge clk);
            #1;

            temperature = 8'd30;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TemperatureSensor Testbench");
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
        input expected_alert;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert)) begin
                $display("PASS");
                $display("  Outputs: alert=%b",
                         alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b",
                         expected_alert);
                $display("  Got:      alert=%b",
                         alert);
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
        $dumpvars(0,clk, reset, temperature, threshold, alert);
    end

endmodule
