`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg motor_ctrl;
    reg rst;
    wire motor_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .motor_ctrl(motor_ctrl),
        .rst(rst),
        .motor_state(motor_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            motor_ctrl = 0;
            @(negedge clk);
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Motor Turn On Check", test_num);
            reset_dut();

            @(negedge clk);
            motor_ctrl = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Motor Turn Off Check", test_num);
            reset_dut();


            @(negedge clk);
            motor_ctrl = 1;
            @(posedge clk);


            @(negedge clk);
            motor_ctrl = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sustained HIGH Check", test_num);
            reset_dut();

            @(negedge clk);
            motor_ctrl = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Override Check", test_num);
            reset_dut();


            @(negedge clk);
            motor_ctrl = 1;
            @(posedge clk);


            @(negedge clk);
            rst = 1;
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_motor_state;
        begin
            if (expected_motor_state === (expected_motor_state ^ motor_state ^ expected_motor_state)) begin
                $display("PASS");
                $display("  Outputs: motor_state=%b",
                         motor_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: motor_state=%b",
                         expected_motor_state);
                $display("  Got:      motor_state=%b",
                         motor_state);
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
        $dumpvars(0,clk, motor_ctrl, rst, motor_state);
    end

endmodule
