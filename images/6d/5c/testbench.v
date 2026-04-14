`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [3:0] en;
    wire [6:0] seg_a;
    wire [6:0] seg_b;
    wire [6:0] seg_c;
    wire [6:0] seg_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .seg_a(seg_a),
        .seg_b(seg_b),
        .seg_c(seg_c),
        .seg_d(seg_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'd0;
            en = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 1 -> 2's Comp 15 (F) -> Seg A", test_num);
            reset_dut();

            data_in = 4'b0000; en = 4'b1111; @(posedge clk); #1;

            data_in = 4'b0001; en = 4'b0001; @(posedge clk); #1;
            #1;

            check_outputs(7'h71, 7'h3f, 7'h3f, 7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 2 -> 2's Comp 14 (E) -> Seg B", test_num);
            reset_dut();
            data_in = 4'b0000; en = 4'b1111; @(posedge clk); #1;
            data_in = 4'b0010; en = 4'b0010; @(posedge clk); #1;
            #1;

            check_outputs(7'h3f, 7'h79, 7'h3f, 7'h3f);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 15 -> 2's Comp 1 -> Seg C", test_num);
            reset_dut();
            data_in = 4'b0000; en = 4'b1111; @(posedge clk); #1;
            data_in = 4'b1111; en = 4'b0100; @(posedge clk); #1;
            #1;

            check_outputs(7'h3f, 7'h3f, 7'h06, 7'h3f);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 8 -> 2's Comp 8 -> Seg D", test_num);
            reset_dut();
            data_in = 4'b0000; en = 4'b1111; @(posedge clk); #1;
            data_in = 4'b1000; en = 4'b1000; @(posedge clk); #1;
            #1;

            check_outputs(7'h3f, 7'h3f, 7'h3f, 7'h7f);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 7 -> 2's Comp 9 -> All Segments", test_num);
            reset_dut();
            data_in = 4'b0111; en = 4'b1111; @(posedge clk); #1;
            #1;

            check_outputs(7'h6f, 7'h6f, 7'h6f, 7'h6f);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence Check (en=0)", test_num);
            reset_dut();

            data_in = 4'b0001; en = 4'b0001; @(posedge clk); #1;

            data_in = 4'b0000; en = 4'b0000; @(posedge clk); #1;
            #1;

            check_outputs(7'h71, 7'hxx, 7'hxx, 7'hxx);
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
        input [6:0] expected_seg_a;
        input [6:0] expected_seg_b;
        input [6:0] expected_seg_c;
        input [6:0] expected_seg_d;
        begin
            if (expected_seg_a === (expected_seg_a ^ seg_a ^ expected_seg_a) &&
                expected_seg_b === (expected_seg_b ^ seg_b ^ expected_seg_b) &&
                expected_seg_c === (expected_seg_c ^ seg_c ^ expected_seg_c) &&
                expected_seg_d === (expected_seg_d ^ seg_d ^ expected_seg_d)) begin
                $display("PASS");
                $display("  Outputs: seg_a=%h, seg_b=%h, seg_c=%h, seg_d=%h",
                         seg_a, seg_b, seg_c, seg_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_a=%h, seg_b=%h, seg_c=%h, seg_d=%h",
                         expected_seg_a, expected_seg_b, expected_seg_c, expected_seg_d);
                $display("  Got:      seg_a=%h, seg_b=%h, seg_c=%h, seg_d=%h",
                         seg_a, seg_b, seg_c, seg_d);
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
        $dumpvars(0,clk, data_in, en, seg_a, seg_b, seg_c, seg_d);
    end

endmodule
