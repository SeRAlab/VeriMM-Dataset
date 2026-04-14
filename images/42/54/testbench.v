`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin;
    reg clk;
    reg reset;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .reset(reset),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bin = 4'h0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            bin = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000000);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            bin = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h3f);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            bin = 4'h1;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            bin = 4'h4;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            bin = 4'h7;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h07);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            bin = 4'h8;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h7f);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            bin = 4'h9;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h6f);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            bin = 4'hA;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h77);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            bin = 4'hD;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h5e);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            bin = 4'hF;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h71);
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
        testcase009();
        testcase010();
        
        
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
        input [6:0] expected_seg;
        begin
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
        $dumpvars(0,bin, clk, reset, seg);
    end

endmodule
