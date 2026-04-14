`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
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
            @(posedge clk);
            reset = 1;
            d = 8'b0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);

            #1;


            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(7'h6d);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(9) @(posedge clk);

            #1;


            check_outputs(7'h6f);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(10) @(posedge clk);

            #1;


            check_outputs(7'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(16) @(posedge clk);

            #1;


            check_outputs(7'h3f);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            d = 8'h80;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(7'h00);
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
        $dumpvars(0,clk, d, reset, seg);
    end

endmodule
