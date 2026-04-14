`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg [7:0] duty_cycle;
    reg [7:0] pwm;
    wire h_bridge_out1;
    wire h_bridge_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .duty_cycle(duty_cycle),
        .pwm(pwm),
        .h_bridge_out1(h_bridge_out1),
        .h_bridge_out2(h_bridge_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dir = 0;
            pwm = 0;
            duty_cycle = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Forward active (dir=1, pwm < duty)", test_num);
            dir = 1;
            duty_cycle = 8'd100;
            pwm = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Forward inactive (dir=1, pwm >= duty)", test_num);
            dir = 1;
            duty_cycle = 8'd100;
            pwm = 8'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Reverse active (dir=0, pwm < duty)", test_num);
            dir = 0;
            duty_cycle = 8'd200;
            pwm = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Reverse inactive (dir=0, pwm >= duty)", test_num);
            dir = 0;
            duty_cycle = 8'd200;
            pwm = 8'd220;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Boundary (pwm == duty)", test_num);
            dir = 1;
            duty_cycle = 8'd128;
            pwm = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: 0%% Duty Cycle", test_num);
            dir = 0;
            duty_cycle = 8'd0;
            pwm = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: Max Duty Cycle", test_num);
            dir = 1;
            duty_cycle = 8'd255;
            pwm = 8'd254;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_h_bridge_out1;
        input expected_h_bridge_out2;
        begin
            if (expected_h_bridge_out1 === (expected_h_bridge_out1 ^ h_bridge_out1 ^ expected_h_bridge_out1) &&
                expected_h_bridge_out2 === (expected_h_bridge_out2 ^ h_bridge_out2 ^ expected_h_bridge_out2)) begin
                $display("PASS");
                $display("  Outputs: h_bridge_out1=%b, h_bridge_out2=%b",
                         h_bridge_out1, h_bridge_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_bridge_out1=%b, h_bridge_out2=%b",
                         expected_h_bridge_out1, expected_h_bridge_out2);
                $display("  Got:      h_bridge_out1=%b, h_bridge_out2=%b",
                         h_bridge_out1, h_bridge_out2);
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
        $dumpvars(0,clk, dir, duty_cycle, pwm, h_bridge_out1, h_bridge_out2);
    end

endmodule
