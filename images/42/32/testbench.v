`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    wire [7:0] seg;
    wire [3:0] segsel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .seg(seg),
        .segsel(segsel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'h0000;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 16'h1234;

            while(segsel !== 4'b1110) @(posedge clk);
            #2;
            #1;

            check_outputs(get_expected_seg(data[3:0]), 4'b1110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 16'h5678;

            while(segsel !== 4'b1101) @(posedge clk);
            #2;
            #1;

            check_outputs(get_expected_seg(data[7:4]), 4'b1101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'hABCD;

            while(segsel !== 4'b1011) @(posedge clk);
            #2;
            #1;

            check_outputs(get_expected_seg(data[11:8]), 4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 16'hF0E1;

            while(segsel !== 4'b0111) @(posedge clk);
            #2;
            #1;

            check_outputs(get_expected_seg(data[15:12]), 4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 16'h8888;
            while(segsel !== 4'b1110) @(posedge clk);
            #2;
            #1;

            check_outputs(get_expected_seg(4'h8), 4'b1110);
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
        input [7:0] expected_seg;
        input [3:0] expected_segsel;
        begin
            if (expected_seg === (expected_seg ^ seg ^ expected_seg) &&
                expected_segsel === (expected_segsel ^ segsel ^ expected_segsel)) begin
                $display("PASS");
                $display("  Outputs: seg=%h, segsel=%h",
                         seg, segsel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h, segsel=%h",
                         expected_seg, expected_segsel);
                $display("  Got:      seg=%h, segsel=%h",
                         seg, segsel);
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
        $dumpvars(0,clk, data, seg, segsel);
    end

endmodule
