`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] din;
    reg rst;
    wire comp;
    wire [23:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .comp(comp),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            $display("Running testcase001: Unique sequence (No Match)...");
            reset_dut();
            for (i = 1; i <= 25; i = i + 1) begin
                din = i;
                @(posedge clk);
            end


            #1;
            #1;

            check_outputs(1'b0, 24'd25);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running testcase002: Repeating sequence (Match at 25th entry)...");
            reset_dut();

            for (i = 1; i <= 24; i = i + 1) begin
                din = i;
                @(posedge clk);
            end

            din = 24'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 24'd1);
        end
        endtask

    task testcase003;

        integer i, j;
        begin
            $display("Running testcase003: Continuous match check (48th entry matches 24th)...");
            reset_dut();
            for (j = 0; j < 2; j = j + 1) begin
                for (i = 1; i <= 24; i = i + 1) begin
                    din = i;
                    @(posedge clk);
                end
            end
            #1;
            #1;

            check_outputs(1'b1, 24'd24);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mismatch after reset...");
            reset_dut();

            din = 24'hAAAAAA;
            @(posedge clk);
            repeat(23) begin
                din = $random;
                @(posedge clk);
            end
            din = 24'hBBBBBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 24'hBBBBBB);
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
        input expected_comp;
        input [23:0] expected_dout;
        begin
            if (expected_comp === (expected_comp ^ comp ^ expected_comp) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: comp=%b, dout=%h",
                         comp, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp=%b, dout=%h",
                         expected_comp, expected_dout);
                $display("  Got:      comp=%b, dout=%h",
                         comp, dout);
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
        $dumpvars(0,clk, din, rst, comp, dout);
    end

endmodule
