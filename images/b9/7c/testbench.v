`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg ce;
    reg clk;
    reg [11:0] data;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce(ce),
        .clk(clk),
        .data(data),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 1'b1;
            data = 12'h000;
            a = 2'b00;
            repeat(4) @(posedge clk);
            ce = 1'b0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write one value and check address 0", test_num);
            reset_dut();
            @(posedge clk);
            ce = 1'b1;
            data = 12'hABC;
            @(posedge clk);
            ce = 1'b0;
            a = 2'd0;
            #2;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shift 4 values and check address 3", test_num);
            reset_dut();
            ce = 1'b1;
            data = 12'h111; @(posedge clk);
            data = 12'h222; @(posedge clk);
            data = 12'h333; @(posedge clk);
            data = 12'h444; @(posedge clk);
            ce = 1'b0;
            a = 2'd3;
            #2;
            #1;

            check_outputs(12'h111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify clock enable functionality", test_num);
            reset_dut();
            ce = 1'b1;
            data = 12'hAAA; @(posedge clk);
            ce = 1'b0;
            data = 12'hBBB; @(posedge clk);
            a = 2'd0;
            #2;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Check address 1 after two shifts", test_num);
            reset_dut();
            ce = 1'b1;
            data = 12'hF0F; @(posedge clk);
            data = 12'h0F0; @(posedge clk);
            ce = 1'b0;
            a = 2'd1;
            #2;
            #1;

            check_outputs(12'hF0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Check address 2 after three shifts", test_num);
            reset_dut();
            ce = 1'b1;
            data = 12'hC0A; @(posedge clk);
            data = 12'hB0B; @(posedge clk);
            data = 12'hA0C; @(posedge clk);
            ce = 1'b0;
            a = 2'd2;
            #2;
            #1;

            check_outputs(12'hC0A);
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
        input [11:0] expected_q;
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
        $dumpvars(0,a, ce, clk, data, q);
    end

endmodule
