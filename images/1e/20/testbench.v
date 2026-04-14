`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] temperature;
    wire [1:0] frequency_level;
    wire [1:0] voltage_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .enable(enable),
        .temperature(temperature),
        .frequency_level(frequency_level),
        .voltage_level(voltage_level)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            temperature = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Controller Disabled", test_num);
            reset_dut();
            enable = 0;
            temperature = 25;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Temperature (Max Performance)", test_num);
            reset_dut();
            enable = 1;
            temperature = 30;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Medium Temperature (Balanced)", test_num);
            reset_dut();
            enable = 1;
            temperature = 65;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Temperature (Power Save)", test_num);
            reset_dut();
            enable = 1;
            temperature = 90;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Critical Temperature (Throttling)", test_num);
            reset_dut();
            enable = 1;
            temperature = 110;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Check (Transition 49 to 50)", test_num);
            reset_dut();
            enable = 1;
            temperature = 49;
            @(posedge clk);
            temperature = 50;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Enable Toggle", test_num);
            reset_dut();
            enable = 1;
            temperature = 25;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [1:0] expected_frequency_level;
        input [1:0] expected_voltage_level;
        begin
            if (expected_frequency_level === (expected_frequency_level ^ frequency_level ^ expected_frequency_level) &&
                expected_voltage_level === (expected_voltage_level ^ voltage_level ^ expected_voltage_level)) begin
                $display("PASS");
                $display("  Outputs: frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_level=%h, voltage_level=%h",
                         expected_frequency_level, expected_voltage_level);
                $display("  Got:      frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
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
        $dumpvars(0,clk, enable, temperature, frequency_level, voltage_level);
    end

endmodule
