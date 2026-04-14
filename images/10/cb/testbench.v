`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] temperature;
    wire [1:0] speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .rst(rst),
        .temperature(temperature),
        .speed(speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temperature = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Temp 0 (Speed 0 range)");
            reset_dut();
            temperature = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Temp 4 (Speed 0 boundary)");
            reset_dut();
            temperature = 4'd4;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Temp 5 (Speed 1 boundary)");
            reset_dut();
            temperature = 4'd5;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Temp 9 (Speed 1 boundary)");
            reset_dut();
            temperature = 4'd9;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Temp 10 (Speed 2 boundary)");
            reset_dut();
            temperature = 4'd10;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Temp 13 (Speed 2 boundary)");
            reset_dut();
            temperature = 4'd13;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Temp 14 (Speed 3 boundary)");
            reset_dut();
            temperature = 4'd14;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd3);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Temp 15 (Speed 3 boundary)");
            reset_dut();
            temperature = 4'd15;
            @(posedge clk);
            #2 #1;
 check_outputs(2'd3);
        end
        endtask

    task testcase009;

        begin
            $display("\nRunning testcase009: Check reset during high temp");
            reset_dut();
            temperature = 4'd15;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #2 #1;
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
        input [1:0] expected_speed;
        begin
            if (expected_speed === (expected_speed ^ speed ^ expected_speed)) begin
                $display("PASS");
                $display("  Outputs: speed=%h",
                         speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speed=%h",
                         expected_speed);
                $display("  Got:      speed=%h",
                         speed);
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
        $dumpvars(0,clk, rst, temperature, speed);
    end

endmodule
