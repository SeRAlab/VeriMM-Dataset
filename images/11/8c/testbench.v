`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] temperature;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .fan_speed(fan_speed)
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
        temperature = 3'b000;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 0 (Range 0-1) -> Expected Speed 0", test_num);
        reset_dut();
        temperature = 3'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 1 (Range 0-1) -> Expected Speed 0", test_num);
        reset_dut();
        temperature = 3'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 2 (Range 2-4) -> Expected Speed 1", test_num);
        reset_dut();
        temperature = 3'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 3 (Range 2-4) -> Expected Speed 1", test_num);
        reset_dut();
        temperature = 3'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 4 (Range 2-4) -> Expected Speed 1", test_num);
        reset_dut();
        temperature = 3'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 5 (Range 5-6) -> Expected Speed 2", test_num);
        reset_dut();
        temperature = 3'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 6 (Range 5-6) -> Expected Speed 2", test_num);
        reset_dut();
        temperature = 3'd6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature 7 (Range 7) -> Expected Speed 3", test_num);
        reset_dut();
        temperature = 3'd7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Reset Priority (Temp 7 but Reset active) -> Expected Speed 0", test_num);
        reset_dut();
        temperature = 3'd7;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_fan_speed;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%h",
                         fan_speed);
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
        $dumpvars(0,clk, reset, temperature, fan_speed);
    end

endmodule
