`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [3:0] add_out;
    wire [7:0] final_out;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .add_out(add_out),
        .final_out(final_out),
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
            d = 8'h01;
            reset_dut();


            d = 8'h00;
            @(posedge clk);


            d = 8'h00;
            @(posedge clk);

            #1;




            $display("Testcase 001: Basic sequence");
            #1;

            check_outputs(4'h2, 8'h03, 8'h04);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            d = 8'h00;
            reset_dut();


            d = 8'h01;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end

            #1;




            $display("Testcase 002: 8-bit shift fill");
            #1;

            check_outputs(4'h8, 8'h86, 8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            d = 8'h00;
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                d = 8'h01;
                @(posedge clk);
            end

            #1;




            $display("Testcase 003: Counter wrap-around");
            #1;

            check_outputs(4'h0, 8'h0E, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            d = 8'hAA;
            reset_dut();

            @(posedge clk);
            @(posedge clk);

            d = 8'hEE;
            reset_dut();

            #1;
            $display("Testcase 004: Mid-operation reset");
            #1;

            check_outputs(4'h0, 8'h00, 8'hEE);
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
        input [3:0] expected_add_out;
        input [7:0] expected_final_out;
        input [7:0] expected_q;
        begin
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out) &&
                expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h, final_out=%h, q=%h",
                         add_out, final_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h, final_out=%h, q=%h",
                         expected_add_out, expected_final_out, expected_q);
                $display("  Got:      add_out=%h, final_out=%h, q=%h",
                         add_out, final_out, q);
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
        $dumpvars(0,clk, d, reset, add_out, final_out, q);
    end

endmodule
