`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] d;
    reg prsn;
    reg rstn;
    wire [4:0] q;
    wire [4:0] qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .prsn(prsn),
        .rstn(rstn),
        .q(q),
        .qn(qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rstn = 0;
            prsn = 1;
            d = 5'b0;
            @(negedge clk);
            rstn = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Active Reset");
            d = 5'h1F;
            rstn = 0;
            prsn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000, 5'b11111);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Active Preset");
            d = 5'h00;
            rstn = 1;
            prsn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Normal Data Load (0x0A)");
            d = 5'h0A;
            rstn = 1;
            prsn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A, 5'h15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Normal Data Load (0x15)");
            d = 5'h15;
            rstn = 1;
            prsn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h15, 5'h0A);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Reset and Preset both active (Priority Check)");
            d = 5'h1C;
            rstn = 0;
            prsn = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000, 5'b11111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Loading all ones");
            d = 5'h1F;
            rstn = 1;
            prsn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1F, 5'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case 007: Loading all zeros");
            d = 5'h00;
            rstn = 1;
            prsn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 5'h1F);
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
        input [4:0] expected_q;
        input [4:0] expected_qn;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qn === (expected_qn ^ qn ^ expected_qn)) begin
                $display("PASS");
                $display("  Outputs: q=%h, qn=%h",
                         q, qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, qn=%h",
                         expected_q, expected_qn);
                $display("  Got:      q=%h, qn=%h",
                         q, qn);
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
        $dumpvars(0,clk, d, prsn, rstn, q, qn);
    end

endmodule
