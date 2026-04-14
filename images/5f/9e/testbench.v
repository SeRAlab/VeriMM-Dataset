`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [31:0] in;
    wire out_final;
    wire parity_bit;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .out_final(out_final),
        .parity_bit(parity_bit),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Parity 1, D 1", test_num);
            d = 1;
            in = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Parity 0, D 1", test_num);
            d = 1;
            in = 32'h00000003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Parity 1, D 0", test_num);
            d = 0;
            in = 32'h00000007;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Parity 0, D 0", test_num);
            d = 0;
            in = 32'h0000000F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Parity 0 (32-bit set), D 1", test_num);
            d = 1;
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Parity 1 (MSB set), D 1", test_num);
            d = 1;
            in = 32'h80000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1);
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
        input expected_out_final;
        input expected_parity_bit;
        input expected_q;
        begin
            if (expected_out_final === (expected_out_final ^ out_final ^ expected_out_final) &&
                expected_parity_bit === (expected_parity_bit ^ parity_bit ^ expected_parity_bit) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_final=%b, parity_bit=%b, q=%b",
                         out_final, parity_bit, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_final=%b, parity_bit=%b, q=%b",
                         expected_out_final, expected_parity_bit, expected_q);
                $display("  Got:      out_final=%b, parity_bit=%b, q=%b",
                         out_final, parity_bit, q);
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
        $dumpvars(0,clk, d, in, out_final, parity_bit, q);
    end

endmodule
