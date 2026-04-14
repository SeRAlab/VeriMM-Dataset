`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] L;
    reg clk;
    reg clk_en;
    reg load_en;
    reg rst;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .L(L),
        .clk(clk),
        .clk_en(clk_en),
        .load_en(load_en),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_en = 0;
            load_en = 0;
            L = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Counting", test_num);
            reset_dut();
            clk_en = 1;
            repeat (10) @(posedge clk);
            #1 #1;
 check_outputs(12'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load Functionality", test_num);
            reset_dut();
            L = 12'hABC;
            load_en = 1;
            @(posedge clk);
            #1 load_en = 0;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Clock Enable Control", test_num);
            reset_dut();
            clk_en = 1;
            repeat (5) @(posedge clk);
            clk_en = 0;
            repeat (5) @(posedge clk);
            #1 #1;
 check_outputs(12'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overflow Wrap-around", test_num);
            reset_dut();
            L = 12'hFFE;
            load_en = 1;
            @(posedge clk);
            #1 load_en = 0;
            clk_en = 1;
            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Load Priority", test_num);
            reset_dut();
            clk_en = 1;
            repeat (3) @(posedge clk);
            L = 12'h555;
            load_en = 1;
            @(posedge clk);
            #1 load_en = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h556);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();
            clk_en = 1;
            repeat (10) @(posedge clk);
            rst = 1;
            load_en = 1;
            L = 12'hFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
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
        input [11:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,L, clk, clk_en, load_en, rst, Q);
    end

endmodule
