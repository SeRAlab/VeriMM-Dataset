`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] ena;
    wire out_and;
    wire out_or;
    wire out_xor;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(3'b000, 1'b0, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b0, 1'b1, 1'b1, 16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001, 1'b0, 1'b1, 1'b0, 16'h000F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(255) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b011, 1'b0, 1'b1, 1'b0, 16'h00FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4095) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b111, 1'b0, 1'b1, 1'b0, 16'h0FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(65535) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b111, 1'b1, 1'b1, 1'b0, 16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b0, 1'b1, 1'b1, 16'h0010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            repeat(65536) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b0, 1'b0, 1'b0, 16'h0000);
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
        input [2:0] expected_ena;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        input [15:0] expected_q;
        begin
            if (expected_ena === (expected_ena ^ ena ^ expected_ena) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: ena=%h, out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         ena, out_and, out_or, out_xor, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ena=%h, out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         expected_ena, expected_out_and, expected_out_or, expected_out_xor, expected_q);
                $display("  Got:      ena=%h, out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         ena, out_and, out_or, out_xor, q);
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
        $dumpvars(0,clk, reset, ena, out_and, out_or, out_xor, q);
    end

endmodule
