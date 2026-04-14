`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [54:0] pipeline_in;
    wire [54:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pipeline_in(pipeline_in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pipeline_in = 55'h0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture All Zeros", test_num);
            reset_dut();
            pipeline_in = 55'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(55'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture All Ones", test_num);
            reset_dut();
            pipeline_in = 55'h7FFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(55'h7FFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture Pattern 0101...", test_num);
            reset_dut();
            pipeline_in = 55'h55555555555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(55'h55555555555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture Pattern 1010...", test_num);
            reset_dut();
            pipeline_in = 55'h2AAAAAAAAAAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(55'h2AAAAAAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture Arbitrary Pattern", test_num);
            reset_dut();
            pipeline_in = 55'h6A0B1C2D3E4F56;
            @(posedge clk);
            #1;
            #1;

            check_outputs(55'h6A0B1C2D3E4F56);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Storage Stability", test_num);
            reset_dut();

            pipeline_in = 55'h123456789ABCDE;
            @(posedge clk);
            #1;

            pipeline_in = 55'h0;
            #2;
            #1;

            check_outputs(55'h123456789ABCDE);
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
        input [54:0] expected_out;
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
        $dumpvars(0,clk, pipeline_in, out);
    end

endmodule
