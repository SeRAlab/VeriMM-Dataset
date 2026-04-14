`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] temperature;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            temperature = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 0-3 (Off)", test_num);
            reset_dut();
            temperature = 4'd2;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 4-7 (Low)", test_num);
            reset_dut();
            temperature = 4'd5;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 8-11 (Medium)", test_num);
            reset_dut();
            temperature = 4'd10;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 12-15 (High)", test_num);
            reset_dut();
            temperature = 4'd14;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Max (15)", test_num);
            reset_dut();
            temperature = 4'd15;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Min (0)", test_num);
            reset_dut();
            temperature = 4'd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Temperature change Low to Medium", test_num);
            reset_dut();
            temperature = 4'd4;
            @(posedge clk);
            temperature = 4'd9;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Temperature change High to Off", test_num);
            reset_dut();
            temperature = 4'd12;
            @(posedge clk);
            temperature = 4'd1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, rst, temperature, fan_speed);
    end

endmodule
