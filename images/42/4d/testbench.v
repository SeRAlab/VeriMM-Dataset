`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk1;
    reg clk2;
    reg req_clk1;
    reg req_clk2;
    reg rst_n;
    reg select;
    wire ack_clk1;
    wire ack_clk2;
    wire clkout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk1(clk1),
        .clk2(clk2),
        .req_clk1(req_clk1),
        .req_clk2(req_clk2),
        .rst_n(rst_n),
        .select(select),
        .ack_clk1(ack_clk1),
        .ack_clk2(ack_clk2),
        .clkout(clkout)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req_clk1 = 0;
            req_clk2 = 0;
            select = 0;
            #25;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #5;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Request clk1 (select=0)", test_num);
            reset_dut();
            select = 0;
            req_clk1 = 1;
            #50;

            wait(clk1 == 1);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Request clk2 (select=1)", test_num);
            reset_dut();
            select = 1;
            req_clk2 = 1;
            #50;

            wait(clk2 == 1);
            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Both requested, select=0 (clk1 priority)", test_num);
            reset_dut();
            select = 0;
            req_clk1 = 1;
            req_clk2 = 1;
            #50;
            wait(clk1 == 1);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Both requested, select=1 (clk2 priority)", test_num);
            reset_dut();
            select = 1;
            req_clk1 = 1;
            req_clk2 = 1;
            #50;
            wait(clk2 == 1);
            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Switching from clk1 to clk2", test_num);
            reset_dut();

            select = 0;
            req_clk1 = 1;
            #50;

            select = 1;
            req_clk2 = 1;
            req_clk1 = 0;
            #100;
            wait(clk2 == 1);
            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: De-assert all requests", test_num);
            reset_dut();
            req_clk1 = 1;
            #50;
            req_clk1 = 0;
            #50;
            #1;

            check_outputs(0, 0, 0);
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
        input expected_ack_clk1;
        input expected_ack_clk2;
        input expected_clkout;
        begin
            if (expected_ack_clk1 === (expected_ack_clk1 ^ ack_clk1 ^ expected_ack_clk1) &&
                expected_ack_clk2 === (expected_ack_clk2 ^ ack_clk2 ^ expected_ack_clk2) &&
                expected_clkout === (expected_clkout ^ clkout ^ expected_clkout)) begin
                $display("PASS");
                $display("  Outputs: ack_clk1=%b, ack_clk2=%b, clkout=%b",
                         ack_clk1, ack_clk2, clkout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_clk1=%b, ack_clk2=%b, clkout=%b",
                         expected_ack_clk1, expected_ack_clk2, expected_clkout);
                $display("  Got:      ack_clk1=%b, ack_clk2=%b, clkout=%b",
                         ack_clk1, ack_clk2, clkout);
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
        $dumpvars(0,clk1, clk2, req_clk1, req_clk2, rst_n, select, ack_clk1, ack_clk2, clkout);
    end

endmodule
