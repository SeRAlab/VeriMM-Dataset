`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] in;
    reg [3:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in <= 64'b0;
            sel <= 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 64'h0000_0000_0000_000F;
            sel = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 001: Match Segment 0 (val=F, sel=0)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 64'h0000_0000_0000_000A;
            sel = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 002: Mismatch Segment 0 (val=A, sel=0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 64'h0000_0000_0000_00F0;
            sel = 4'd1;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 003: Match Segment 1 (val=F, sel=1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 64'h0000_0000_0000_0F00;
            sel = 4'd2;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 004: Match Segment 2 (val=F, sel=2)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 64'h0000_0000_0000_F000;
            sel = 4'd3;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 005: Match Segment 3 (val=F, sel=3)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in = 64'hFFFF_FFFF_FFFF_FFF0;
            sel = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 006: Mismatch check (Other segs are F, target seg is 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            sel = 4'd3;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 007: All segments F, verify selection 3");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in = 64'hAAAA_AAAA_AAAA_A000;
            sel = 4'd3;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 008: High bit noise check");
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,clk, in, sel, out);
    end

endmodule
