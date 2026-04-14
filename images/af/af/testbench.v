`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Q;
    reg rd_clk;
    reg sel;
    wire [11:0] O1;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .rd_clk(rd_clk),
        .sel(sel),
        .O1(O1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            Q = 1;
            sel = 0;
            @(posedge rd_clk);
            #1;
            Q = 0;
            @(posedge rd_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'd0, 12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment count by 5", test_num);
            reset_dut();
            sel = 1;
            repeat(5) @(posedge rd_clk);
            #1;
            sel = 0;
            #1;

            check_outputs(12'd5, 12'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment with sel toggling", test_num);
            reset_dut();

            sel = 1;
            repeat(2) @(posedge rd_clk);
            #1;
            sel = 0;
            repeat(2) @(posedge rd_clk);
            #1;
            sel = 1;
            repeat(3) @(posedge rd_clk);
            #1;
            sel = 0;

            #1;


            check_outputs(12'd5, 12'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation reset", test_num);
            reset_dut();

            sel = 1;
            repeat(10) @(posedge rd_clk);
            #1;

            Q = 1;
            @(posedge rd_clk);
            #1;
            Q = 0;
            sel = 0;

            #1;


            check_outputs(12'd0, 12'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large count test (128)", test_num);
            reset_dut();

            sel = 1;
            repeat(128) @(posedge rd_clk);
            #1;
            sel = 0;

            #1;


            check_outputs(12'd128, 12'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single step increment", test_num);
            reset_dut();

            sel = 1;
            @(posedge rd_clk);
            #1;
            sel = 0;

            #1;


            check_outputs(12'd1, 12'd1);
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
        input [11:0] expected_O1;
        input [11:0] expected_out;
        begin
            if (expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: O1=%h, out=%h",
                         O1, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O1=%h, out=%h",
                         expected_O1, expected_out);
                $display("  Got:      O1=%h, out=%h",
                         O1, out);
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
        $dumpvars(0,Q, rd_clk, sel, O1, out);
    end

endmodule
