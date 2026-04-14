`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg sel_b1;
    reg sel_b2;
    reg sel_out;
    wire out_always;
    wire out_logical_inv;
    wire [3:0] out_xor;
    wire [3:0] out_xor_inv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .sel_out(sel_out),
        .out_always(out_always),
        .out_logical_inv(out_logical_inv),
        .out_xor(out_xor),
        .out_xor_inv(out_xor_inv)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'b0;
            b = 4'b0;
            sel_b1 = 0;
            sel_b2 = 0;
            sel_out = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 4'b1010; b = 4'b0101; sel_b1 = 1; sel_b2 = 1; sel_out = 0;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b0, 1'b0, 4'b1111, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 4'b1100; b = 4'b0011; sel_b1 = 1; sel_b2 = 1; sel_out = 1;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b0, 1'b0, 4'b1111, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = 4'b1010; b = 4'b0101; sel_b1 = 0; sel_b2 = 0; sel_out = 0;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b1, 1'b1, 4'b0000, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 4'b1111; b = 4'b0000; sel_b1 = 0; sel_b2 = 0; sel_out = 1;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b1, 1'b1, 4'b0000, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 4'b1111; b = 4'b1111; sel_b1 = 1; sel_b2 = 1; sel_out = 0;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b1, 1'b1, 4'b0000, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = 4'b1110; b = 4'b0000; sel_b1 = 1; sel_b2 = 1; sel_out = 0;
            @(posedge clk); #2;
            #1;

            check_outputs(1'b1, 1'b0, 4'b1110, 4'b0001);
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
        input expected_out_always;
        input expected_out_logical_inv;
        input [3:0] expected_out_xor;
        input [3:0] expected_out_xor_inv;
        begin
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always) &&
                expected_out_logical_inv === (expected_out_logical_inv ^ out_logical_inv ^ expected_out_logical_inv) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_out_xor_inv === (expected_out_xor_inv ^ out_xor_inv ^ expected_out_xor_inv)) begin
                $display("PASS");
                $display("  Outputs: out_always=%b, out_logical_inv=%b, out_xor=%h, out_xor_inv=%h",
                         out_always, out_logical_inv, out_xor, out_xor_inv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%b, out_logical_inv=%b, out_xor=%h, out_xor_inv=%h",
                         expected_out_always, expected_out_logical_inv, expected_out_xor, expected_out_xor_inv);
                $display("  Got:      out_always=%b, out_logical_inv=%b, out_xor=%h, out_xor_inv=%h",
                         out_always, out_logical_inv, out_xor, out_xor_inv);
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
        $dumpvars(0,a, b, clk, sel_b1, sel_b2, sel_out, out_always, out_logical_inv, out_xor, out_xor_inv);
    end

endmodule
