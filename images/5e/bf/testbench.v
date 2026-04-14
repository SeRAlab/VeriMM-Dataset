`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sel0;
    reg sel1;
    reg sel2;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sel2 = 0; sel1 = 0; sel0 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 000", test_num);
            reset_dut();
            sel2 = 0; sel1 = 0; sel0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 001", test_num);
            reset_dut();
            sel2 = 0; sel1 = 0; sel0 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 010", test_num);
            reset_dut();
            sel2 = 0; sel1 = 1; sel0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 011", test_num);
            reset_dut();
            sel2 = 0; sel1 = 1; sel0 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000008);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 100", test_num);
            reset_dut();
            sel2 = 1; sel1 = 0; sel0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 101", test_num);
            reset_dut();
            sel2 = 1; sel1 = 0; sel0 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000020);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 110", test_num);
            reset_dut();
            sel2 = 1; sel1 = 1; sel0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000040);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Binary 111", test_num);
            reset_dut();
            sel2 = 1; sel1 = 1; sel0 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000080);
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
        input [63:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, sel0, sel1, sel2, out);
    end

endmodule
