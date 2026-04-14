`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] cmd;
    reg [5:0] current_angles;
    reg rst;
    wire joint0_pwm;
    wire joint1_pwm;
    wire joint2_pwm;
    wire joint3_pwm;
    wire joint4_pwm;
    wire joint5_pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmd(cmd),
        .current_angles(current_angles),
        .rst(rst),
        .joint0_pwm(joint0_pwm),
        .joint1_pwm(joint1_pwm),
        .joint2_pwm(joint2_pwm),
        .joint3_pwm(joint3_pwm),
        .joint4_pwm(joint4_pwm),
        .joint5_pwm(joint5_pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cmd = 6'b000000;
            current_angles = 6'b000000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initialization via reset", test_num);
            current_angles = 6'b101010;
            reset_dut();

            @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Update single joint (Joint 0)", test_num);
            current_angles = 6'b000000;
            reset_dut();

            @(posedge clk);
            current_angles = 6'b000001;
            cmd = 6'b000001;
            @(posedge clk);
            cmd = 6'b000000;

            @(posedge clk);
            #1;

            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Update multiple joints (1, 3, 5)", test_num);
            current_angles = 6'b000000;
            reset_dut();

            @(posedge clk);
            current_angles = 6'b101010;
            cmd = 6'b101010;
            @(posedge clk);
            cmd = 6'b000000;

            @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No update when cmd=0", test_num);
            current_angles = 6'b111111;
            reset_dut();

            @(posedge clk);
            current_angles = 6'b000000;
            cmd = 6'b000000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Selective update (Joints 4 & 5 to 0)", test_num);
            current_angles = 6'b111111;
            reset_dut();

            @(posedge clk);
            current_angles = 6'b001111;
            cmd = 6'b110000;
            @(posedge clk);
            cmd = 6'b000000;

            @(posedge clk);
            #1;

            check_outputs(1, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset to all zeros", test_num);
            current_angles = 6'b000000;
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
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
        input expected_joint0_pwm;
        input expected_joint1_pwm;
        input expected_joint2_pwm;
        input expected_joint3_pwm;
        input expected_joint4_pwm;
        input expected_joint5_pwm;
        begin
            if (expected_joint0_pwm === (expected_joint0_pwm ^ joint0_pwm ^ expected_joint0_pwm) &&
                expected_joint1_pwm === (expected_joint1_pwm ^ joint1_pwm ^ expected_joint1_pwm) &&
                expected_joint2_pwm === (expected_joint2_pwm ^ joint2_pwm ^ expected_joint2_pwm) &&
                expected_joint3_pwm === (expected_joint3_pwm ^ joint3_pwm ^ expected_joint3_pwm) &&
                expected_joint4_pwm === (expected_joint4_pwm ^ joint4_pwm ^ expected_joint4_pwm) &&
                expected_joint5_pwm === (expected_joint5_pwm ^ joint5_pwm ^ expected_joint5_pwm)) begin
                $display("PASS");
                $display("  Outputs: joint0_pwm=%b, joint1_pwm=%b, joint2_pwm=%b, joint3_pwm=%b, joint4_pwm=%b, joint5_pwm=%b",
                         joint0_pwm, joint1_pwm, joint2_pwm, joint3_pwm, joint4_pwm, joint5_pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: joint0_pwm=%b, joint1_pwm=%b, joint2_pwm=%b, joint3_pwm=%b, joint4_pwm=%b, joint5_pwm=%b",
                         expected_joint0_pwm, expected_joint1_pwm, expected_joint2_pwm, expected_joint3_pwm, expected_joint4_pwm, expected_joint5_pwm);
                $display("  Got:      joint0_pwm=%b, joint1_pwm=%b, joint2_pwm=%b, joint3_pwm=%b, joint4_pwm=%b, joint5_pwm=%b",
                         joint0_pwm, joint1_pwm, joint2_pwm, joint3_pwm, joint4_pwm, joint5_pwm);
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
        $dumpvars(0,clk, cmd, current_angles, rst, joint0_pwm, joint1_pwm, joint2_pwm, joint3_pwm, joint4_pwm, joint5_pwm);
    end

endmodule
