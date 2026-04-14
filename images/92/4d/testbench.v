`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [36:0] d;
    reg set;
    wire [36:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .set(set),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            set = 0;
            d = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Set priority over data");
            reset_dut();
            set = 1;
            d = 37'h0_AAAAAAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h1_FFFF_FFFFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load all zeros");
            reset_dut();
            set = 0;
            d = 37'h0_0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h0_0000_0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load all ones via data input");
            reset_dut();
            set = 0;
            d = 37'h1_FFFF_FFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h1_FFFF_FFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load alternating bit pattern 0x1555555555");
            reset_dut();
            set = 0;
            d = 37'h1_5555_55555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h1_5555_55555);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transition from Set high to Set low");
            reset_dut();

            set = 1;
            @(posedge clk);
            #1;

            set = 0;
            d = 37'h0_1234_56789;
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h0_1234_56789);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Data persistence over multiple cycles");
            reset_dut();
            set = 0;
            d = 37'h0_F0F0_F0F0F;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h0_F0F0_F0F0F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load large arbitrary hex value");
            reset_dut();
            set = 0;
            d = 37'h1_BADA_BEEF1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(37'h1_BADA_BEEF1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Rapid toggle between Set and Data");
            reset_dut();
            set = 1; d = 37'h0; @(posedge clk);
            set = 0; d = 37'h0_CAFE_BABE1; @(posedge clk);
            set = 1; d = 37'h0; @(posedge clk);
            set = 0; d = 37'h1_0000_00001; @(posedge clk);
            #1;
            #1;

            check_outputs(37'h1_0000_00001);
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
        testcase008();
        
        
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
        input [36:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, set, q);
    end

endmodule
