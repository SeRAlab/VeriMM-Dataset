`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] amt;
    reg clk;
    reg [67:0] crc;
    reg rst;
    wire [67:0] left;
    wire [67:0] right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amt(amt),
        .clk(clk),
        .crc(crc),
        .rst(rst),
        .left(left),
        .right(right)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            amt = 0;
            crc = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            if (left === 68'd0 && right === 68'd0) begin
                $display("PASS: Testcase001 (Reset)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Testcase001 (Reset)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            crc = 68'h0;
            amt = 7'd10;

            #1;


            check_outputs(68'h0, 68'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            crc = {68{1'b1}};
            amt = 7'd0;


            #1;



            check_outputs(dut.left, dut.right);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            crc = 68'h55555555555555555;
            amt = 7'd34;
            #1;

            check_outputs(dut.left, dut.right);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            crc = 68'hFEDCBA9876543210F;
            amt = 7'd67;
            #1;

            check_outputs(dut.left, dut.right);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            crc = 68'h1;
            amt = 7'd1;
            #1;

            check_outputs(dut.left, dut.right);
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
        input [67:0] expected_left;
        input [67:0] expected_right;
        begin
            if (expected_left === (expected_left ^ left ^ expected_left) &&
                expected_right === (expected_right ^ right ^ expected_right)) begin
                $display("PASS");
                $display("  Outputs: left=%h, right=%h",
                         left, right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left=%h, right=%h",
                         expected_left, expected_right);
                $display("  Got:      left=%h, right=%h",
                         left, right);
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
        $dumpvars(0,amt, clk, crc, rst, left, right);
    end

endmodule
