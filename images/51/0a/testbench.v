`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] b;
    reg clk;
    reg [11:0] e;
    reg reset;
    wire [11:0] q;
    wire [11:0] rb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .clk(clk),
        .e(e),
        .reset(reset),
        .q(q),
        .rb(rb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            b = 12'b0;
            e = 12'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Propagation (ABC, 123)", test_num);
            reset_dut();
            @(negedge clk);
            b = 12'hABC;
            e = 12'h123;

            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(12'hABC, 12'h123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (FFF, 000)", test_num);
            reset_dut();
            @(negedge clk);
            b = 12'hFFF;
            e = 12'h000;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF, 12'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (5AA, A55)", test_num);
            reset_dut();
            @(negedge clk);
            b = 12'h5AA;
            e = 12'hA55;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(12'h5AA, 12'hA55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence check (001, 800)", test_num);
            reset_dut();
            @(negedge clk);
            b = 12'h001;
            e = 12'h800;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(12'h001, 12'h800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Reset state after operation", test_num);
            reset_dut();
            @(negedge clk);
            b = 12'hFFF;
            e = 12'hFFF;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000, 12'h000);
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
        input [11:0] expected_rb;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_rb === (expected_rb ^ rb ^ expected_rb)) begin
                $display("PASS");
                $display("  Outputs: q=%h, rb=%h",
                         q, rb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, rb=%h",
                         expected_q, expected_rb);
                $display("  Got:      q=%h, rb=%h",
                         q, rb);
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
        $dumpvars(0,b, clk, e, reset, q, rb);
    end

endmodule
