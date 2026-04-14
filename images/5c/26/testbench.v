`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [23:0] b;
    reg ce;
    reg clk;
    wire [30:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            a = 0;
            b = 0;
            wait_cycles(2);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'hFF;
            b = 24'h0;
            ce = 1;
            wait_cycles(1);
            #1;

            check_outputs(31'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd10;
            b = 24'd500;
            ce = 1;
            wait_cycles(1);
            #1;

            check_outputs(31'd5000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd1;
            b = 24'hABCDEF;
            ce = 1;
            wait_cycles(1);
            #1;

            check_outputs(31'hABCDEF);
        end
        endtask

    task testcase004;

        reg [30:0] prev_p;
        begin
            reset_dut();
            test_num = test_num + 1;

            a = 8'd5;
            b = 24'd10;
            ce = 1;
            wait_cycles(1);
            prev_p = p;


            a = 8'd10;
            b = 24'd20;
            ce = 0;
            wait_cycles(2);

            #1;


            check_outputs(prev_p);
        end
        endtask

    task testcase005;

        reg [63:0] full_prod;
        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'hFF;
            b = 24'hFFFFFF;
            ce = 1;
            wait_cycles(1);
            full_prod = 8'hFF * 24'hFFFFFF;
            #1;

            check_outputs(full_prod[30:0]);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'h80;
            b = 24'h10000;
            ce = 1;
            wait_cycles(1);

            #1;


            check_outputs(31'h800000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            ce = 1;

            a = 8'd2; b = 24'd4;
            wait_cycles(1);

            a = 8'd3; b = 24'd6;
            #1;

            check_outputs(31'd8);

            wait_cycles(1);
            #1;

            check_outputs(31'd18);
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
        input [30:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
