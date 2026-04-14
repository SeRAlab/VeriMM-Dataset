`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mouseleft_in;
    reg rst;
    reg [11:0] xpos_in;
    reg [11:0] ypos_in;
    wire mouseleft_out;
    wire [11:0] xpos_out;
    wire [11:0] ypos_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mouseleft_in(mouseleft_in),
        .rst(rst),
        .xpos_in(xpos_in),
        .ypos_in(ypos_in),
        .mouseleft_out(mouseleft_out),
        .xpos_out(xpos_out),
        .ypos_out(ypos_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            xpos_in = 12'd0;
            ypos_in = 12'd0;
            mouseleft_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            reset_dut();


            #1;



            check_outputs(1'b0, 12'h000, 12'h000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Normal Data Capture");
            reset_dut();
            xpos_in = 12'hABC;
            ypos_in = 12'h123;
            mouseleft_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 12'hABC, 12'h123);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Maximum Boundary Values");
            reset_dut();
            xpos_in = 12'hFFF;
            ypos_in = 12'hFFF;
            mouseleft_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 12'hFFF, 12'hFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Successive Updates");
            reset_dut();

            xpos_in = 12'd100;
            ypos_in = 12'd200;
            mouseleft_in = 1'b0;
            @(posedge clk);
            #1;

            xpos_in = 12'd300;
            ypos_in = 12'd400;
            mouseleft_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 12'd300, 12'd400);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Dominance");
            reset_dut();

            xpos_in = 12'hAAA;
            ypos_in = 12'hBBB;
            mouseleft_in = 1'b1;
            @(posedge clk);
            #1;

            rst = 1;
            xpos_in = 12'h555;
            ypos_in = 12'h666;
            mouseleft_in = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 12'h000, 12'h000);
            rst = 0;
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
        input expected_mouseleft_out;
        input [11:0] expected_xpos_out;
        input [11:0] expected_ypos_out;
        begin
            if (expected_mouseleft_out === (expected_mouseleft_out ^ mouseleft_out ^ expected_mouseleft_out) &&
                expected_xpos_out === (expected_xpos_out ^ xpos_out ^ expected_xpos_out) &&
                expected_ypos_out === (expected_ypos_out ^ ypos_out ^ expected_ypos_out)) begin
                $display("PASS");
                $display("  Outputs: mouseleft_out=%b, xpos_out=%h, ypos_out=%h",
                         mouseleft_out, xpos_out, ypos_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mouseleft_out=%b, xpos_out=%h, ypos_out=%h",
                         expected_mouseleft_out, expected_xpos_out, expected_ypos_out);
                $display("  Got:      mouseleft_out=%b, xpos_out=%h, ypos_out=%h",
                         mouseleft_out, xpos_out, ypos_out);
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
        $dumpvars(0,clk, mouseleft_in, rst, xpos_in, ypos_in, mouseleft_out, xpos_out, ypos_out);
    end

endmodule
