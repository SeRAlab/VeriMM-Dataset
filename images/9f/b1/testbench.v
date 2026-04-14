`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] speed;
    wire [7:0] motor_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .speed(speed),
        .motor_speed(motor_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            speed = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mid-range Speed (0x55)", test_num);
            reset_dut();
            speed = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Maximum Speed (0xFF)", test_num);
            reset_dut();
            speed = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Minimum Speed (0x01)", test_num);
            reset_dut();
            speed = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Sequential Speed Updates", test_num);
            reset_dut();


            speed = 8'h10;
            @(posedge clk);


            speed = 8'hA5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Clock Edge Synchronization", test_num);
            reset_dut();


            speed = 8'h22;
            @(posedge clk);
            #1;


            speed = 8'h44;
            #2;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h44);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_motor_speed;
        begin
            if (expected_motor_speed === (expected_motor_speed ^ motor_speed ^ expected_motor_speed)) begin
                $display("PASS");
                $display("  Outputs: motor_speed=%h",
                         motor_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: motor_speed=%h",
                         expected_motor_speed);
                $display("  Got:      motor_speed=%h",
                         motor_speed);
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
        $dumpvars(0,clk, rst, speed, motor_speed);
    end

endmodule
