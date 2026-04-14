`timescale 1ns/1ps

module TemperatureSensorController_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] temperature;
    wire high_temp_alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TemperatureSensorController dut (
        .clk(clk),
        .temperature(temperature),
        .high_temp_alert(high_temp_alert)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            temperature <= 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 0", test_num);
            reset_dut();

            temperature <= 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 7", test_num);
            reset_dut();

            temperature <= 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 15", test_num);
            reset_dut();

            temperature <= 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid input change sequence", test_num);
            reset_dut();

            temperature <= 4'd2;
            @(posedge clk);
            temperature <= 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TemperatureSensorController Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_high_temp_alert;
        begin
            if (expected_high_temp_alert === (expected_high_temp_alert ^ high_temp_alert ^ expected_high_temp_alert)) begin
                $display("PASS");
                $display("  Outputs: high_temp_alert=%b",
                         high_temp_alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_temp_alert=%b",
                         expected_high_temp_alert);
                $display("  Got:      high_temp_alert=%b",
                         high_temp_alert);
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
        $dumpvars(0,clk, temperature, high_temp_alert);
    end

endmodule
