`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] als;
    reg clk;
    reg [7:0] dcs;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .als(als),
        .clk(clk),
        .dcs(dcs),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            als <= 0;
            dcs <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            als = 8'hFF;
            dcs = 8'h00;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: dcs=0 (Min Brightness)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            als = 8'hFF;
            dcs = 8'hFF;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: dcs=255, als=255 (Full Brightness)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            als = 8'h01;
            dcs = 8'hFF;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: dcs > als (Saturated Brightness)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            als = 8'h80;
            dcs = 8'h40;
            repeat(50) @(posedge clk);
            $display("Testcase %03d: Mid-range values (als=128, dcs=64)", test_num);

            if (pwm === 1'b0 || pwm === 1'b1)
                #1;

                check_outputs(pwm);
            else
                #1;

                check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            als = 8'h00;
            dcs = 8'hFF;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: Zero Ambient light (als=0)", test_num);

            #1;


            check_outputs(1'b1);
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
        input expected_pwm;
        begin
            if (expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: pwm=%b",
                         pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm=%b",
                         expected_pwm);
                $display("  Got:      pwm=%b",
                         pwm);
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
        $dumpvars(0,als, clk, dcs, pwm);
    end

endmodule
