`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] npm0;
    reg [3:0] npm1;
    reg [3:0] npm2;
    reg [3:0] npm3;
    reg reset;
    wire [3:0] pm0;
    wire [3:0] pm1;
    wire [3:0] pm2;
    wire [3:0] pm3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .npm0(npm0),
        .npm1(npm1),
        .npm2(npm2),
        .npm3(npm3),
        .reset(reset),
        .pm0(pm0),
        .pm1(pm1),
        .pm2(pm2),
        .pm3(pm3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            npm0 = 4'd0;
            npm1 = 4'd0;
            npm2 = 4'd0;
            npm3 = 4'd0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Sequential values", test_num);
            reset_dut();
            npm0 = 4'h1;
            npm1 = 4'h2;
            npm2 = 4'h3;
            npm3 = 4'h4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1, 4'h2, 4'h3, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Alternating bit patterns", test_num);
            reset_dut();
            npm0 = 4'hA;
            npm1 = 4'h5;
            npm2 = 4'hA;
            npm3 = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA, 4'h5, 4'hA, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Maximum values (0xF)", test_num);
            reset_dut();
            npm0 = 4'hF;
            npm1 = 4'hF;
            npm2 = 4'hF;
            npm3 = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Walking ones pattern", test_num);
            reset_dut();
            npm0 = 4'h1;
            npm1 = 4'h2;
            npm2 = 4'h4;
            npm3 = 4'h8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1, 4'h2, 4'h4, 4'h8);
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
        input [3:0] expected_pm0;
        input [3:0] expected_pm1;
        input [3:0] expected_pm2;
        input [3:0] expected_pm3;
        begin
            if (expected_pm0 === (expected_pm0 ^ pm0 ^ expected_pm0) &&
                expected_pm1 === (expected_pm1 ^ pm1 ^ expected_pm1) &&
                expected_pm2 === (expected_pm2 ^ pm2 ^ expected_pm2) &&
                expected_pm3 === (expected_pm3 ^ pm3 ^ expected_pm3)) begin
                $display("PASS");
                $display("  Outputs: pm0=%h, pm1=%h, pm2=%h, pm3=%h",
                         pm0, pm1, pm2, pm3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pm0=%h, pm1=%h, pm2=%h, pm3=%h",
                         expected_pm0, expected_pm1, expected_pm2, expected_pm3);
                $display("  Got:      pm0=%h, pm1=%h, pm2=%h, pm3=%h",
                         pm0, pm1, pm2, pm3);
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
        $dumpvars(0,clk, npm0, npm1, npm2, npm3, reset, pm0, pm1, pm2, pm3);
    end

endmodule
