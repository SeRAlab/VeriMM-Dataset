`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] desired_speed;
    reg reset;
    wire [2:0] actual_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .desired_speed(desired_speed),
        .reset(reset),
        .actual_speed(actual_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            desired_speed = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Ramp up 0 to 7");
            test_num = test_num + 1;
            reset_dut();
            desired_speed = 7;

            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(3'd7);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Ramp up to 5, then down to 2");
            test_num = test_num + 1;
            reset_dut();

            desired_speed = 5;
            repeat(5) @(posedge clk);

            desired_speed = 2;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Check steady state at speed 4");
            test_num = test_num + 1;
            reset_dut();
            desired_speed = 4;
            repeat(4) @(posedge clk);
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Mid-ramp target change");
            test_num = test_num + 1;
            reset_dut();
            desired_speed = 6;
            repeat(3) @(posedge clk);
            desired_speed = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Desired speed remains 0");
            test_num = test_num + 1;
            reset_dut();
            desired_speed = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Ramp down 7 to 0");
            test_num = test_num + 1;
            reset_dut();
            desired_speed = 7;
            repeat(7) @(posedge clk);
            desired_speed = 0;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Assert reset while at high speed");
            test_num = test_num + 1;
            reset_dut();
            desired_speed = 5;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
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
        input [2:0] expected_actual_speed;
        begin
            if (expected_actual_speed === (expected_actual_speed ^ actual_speed ^ expected_actual_speed)) begin
                $display("PASS");
                $display("  Outputs: actual_speed=%h",
                         actual_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: actual_speed=%h",
                         expected_actual_speed);
                $display("  Got:      actual_speed=%h",
                         actual_speed);
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
        $dumpvars(0,clk, desired_speed, reset, actual_speed);
    end

endmodule
