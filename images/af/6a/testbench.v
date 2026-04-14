`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk1;
    reg clk2;
    reg en1;
    reg en2;
    reg rst_n1;
    reg rst_n2;
    wire clk1_div;
    wire clk1_g;
    wire clk2_g;
    wire rst_n_reg1;
    wire rst_n_reg2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk1(clk1),
        .clk2(clk2),
        .en1(en1),
        .en2(en2),
        .rst_n1(rst_n1),
        .rst_n2(rst_n2),
        .clk1_div(clk1_div),
        .clk1_g(clk1_g),
        .clk2_g(clk2_g),
        .rst_n_reg1(rst_n_reg1),
        .rst_n_reg2(rst_n_reg2)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
    end

        task reset_dut;

        begin
            rst_n1 = 0;
            rst_n2 = 0;
            en1 = 0;
            en2 = 0;
            #20;
            rst_n1 = 1;
            rst_n2 = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Reset State", test_num);

            rst_n1 = 0; rst_n2 = 0; en1 = 0; en2 = 0;
            #15;

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Enable clk1 and rst_n1", test_num);
            reset_dut();
            en1 = 1;
            rst_n1 = 1;

            @(posedge clk1);
            #2;

            #1;


            check_outputs(1, 1, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: clk1_div Toggle Logic", test_num);
            reset_dut();
            en1 = 1;
            rst_n1 = 1;
            @(posedge clk1);
            @(posedge clk1);
            #2;

            #1;


            check_outputs(0, 1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Enable clk2 and rst_n2", test_num);
            reset_dut();
            en2 = 1;
            rst_n2 = 1;
            @(posedge clk2);
            #2;

            #1;


            check_outputs(0, 0, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Clock Gating (en=0)", test_num);
            reset_dut();
            rst_n1 = 1;
            en1 = 0;
            @(posedge clk1);
            #2;


            #1;



            check_outputs(1, 0, 0, 1, 0);
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
        input expected_clk1_div;
        input expected_clk1_g;
        input expected_clk2_g;
        input expected_rst_n_reg1;
        input expected_rst_n_reg2;
        begin
            if (expected_clk1_div === (expected_clk1_div ^ clk1_div ^ expected_clk1_div) &&
                expected_clk1_g === (expected_clk1_g ^ clk1_g ^ expected_clk1_g) &&
                expected_clk2_g === (expected_clk2_g ^ clk2_g ^ expected_clk2_g) &&
                expected_rst_n_reg1 === (expected_rst_n_reg1 ^ rst_n_reg1 ^ expected_rst_n_reg1) &&
                expected_rst_n_reg2 === (expected_rst_n_reg2 ^ rst_n_reg2 ^ expected_rst_n_reg2)) begin
                $display("PASS");
                $display("  Outputs: clk1_div=%b, clk1_g=%b, clk2_g=%b, rst_n_reg1=%b, rst_n_reg2=%b",
                         clk1_div, clk1_g, clk2_g, rst_n_reg1, rst_n_reg2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk1_div=%b, clk1_g=%b, clk2_g=%b, rst_n_reg1=%b, rst_n_reg2=%b",
                         expected_clk1_div, expected_clk1_g, expected_clk2_g, expected_rst_n_reg1, expected_rst_n_reg2);
                $display("  Got:      clk1_div=%b, clk1_g=%b, clk2_g=%b, rst_n_reg1=%b, rst_n_reg2=%b",
                         clk1_div, clk1_g, clk2_g, rst_n_reg1, rst_n_reg2);
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
        $dumpvars(0,clk1, clk2, en1, en2, rst_n1, rst_n2, clk1_div, clk1_g, clk2_g, rst_n_reg1, rst_n_reg2);
    end

endmodule
