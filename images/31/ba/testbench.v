`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] desired_speed;
    reg fan_on;
    reg rst;
    wire [2:0] current_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .desired_speed(desired_speed),
        .fan_on(fan_on),
        .rst(rst),
        .current_speed(current_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            fan_on = 0;
            desired_speed = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fan ON at speed 3", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fan OFF with speed input 5", test_num);
            reset_dut();

            fan_on = 0;
            desired_speed = 3'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change speed while ON (from 2 to 7)", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd2;
            @(posedge clk);

            desired_speed = 3'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Turning fan OFF while running", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd4;
            @(posedge clk);

            fan_on = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum speed limit (7)", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum non-zero speed (1)", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd6;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fan ON but speed set to 0", test_num);
            reset_dut();

            fan_on = 1;
            desired_speed = 3'd0;
            @(posedge clk);
            #1;

            #1;


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
        input [2:0] expected_current_speed;
        begin
            if (expected_current_speed === (expected_current_speed ^ current_speed ^ expected_current_speed)) begin
                $display("PASS");
                $display("  Outputs: current_speed=%h",
                         current_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_speed=%h",
                         expected_current_speed);
                $display("  Got:      current_speed=%h",
                         current_speed);
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
        $dumpvars(0,clk, desired_speed, fan_on, rst, current_speed);
    end

endmodule
