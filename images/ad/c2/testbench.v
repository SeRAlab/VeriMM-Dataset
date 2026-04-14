`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] pw_bl;
    reg [25:0] pw_w_base;
    reg [16:0] w_pw_en_cnt;
    wire [25:0] pw_w_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pw_bl(pw_bl),
        .pw_w_base(pw_w_base),
        .w_pw_en_cnt(w_pw_en_cnt),
        .pw_w_addr(pw_w_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pw_bl = 0;
            pw_w_base = 0;
            w_pw_en_cnt = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            pw_w_base = 26'h0000100;
            w_pw_en_cnt = 17'd10;
            pw_bl = 7'd8;

            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h0000150);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            pw_w_base = 26'h0000000;
            w_pw_en_cnt = 17'd50;
            pw_bl = 7'd4;

            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h00000C8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            pw_w_base = 26'h1ABCDEF;
            w_pw_en_cnt = 17'd0;
            pw_bl = 7'd127;

            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h1ABCDEF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            pw_w_base = 26'h2555555;
            w_pw_en_cnt = 17'h1FFFF;
            pw_bl = 7'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h2555555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            pw_w_base = 26'h1000000;
            w_pw_en_cnt = 17'd1000;
            pw_bl = 7'd100;


            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h10186A0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            pw_w_base = 26'h0000001;
            w_pw_en_cnt = 17'h1FFFF;
            pw_bl = 7'h7F;

            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h0FE5F82);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            pw_w_base = 26'h3FFFFF0;
            w_pw_en_cnt = 17'd10;
            pw_bl = 7'd8;


            @(posedge clk);
            #1;
            #1;

            check_outputs(26'h0000040);
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
        input [25:0] expected_pw_w_addr;
        begin
            if (expected_pw_w_addr === (expected_pw_w_addr ^ pw_w_addr ^ expected_pw_w_addr)) begin
                $display("PASS");
                $display("  Outputs: pw_w_addr=%h",
                         pw_w_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pw_w_addr=%h",
                         expected_pw_w_addr);
                $display("  Got:      pw_w_addr=%h",
                         pw_w_addr);
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
        $dumpvars(0,clk, pw_bl, pw_w_base, w_pw_en_cnt, pw_w_addr);
    end

endmodule
