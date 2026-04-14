`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] I1;
    reg Q;
    reg [11:0] WR_PNTR_RD;
    reg [11:0] out;
    reg rd_clk;
    reg rd_en;
    wire E;
    wire O1;
    wire empty;
    wire p_18_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .Q(Q),
        .WR_PNTR_RD(WR_PNTR_RD),
        .out(out),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .E(E),
        .O1(O1),
        .empty(empty),
        .p_18_out(p_18_out)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            Q = 1;
            rd_en = 0;
            I1 = 12'd0;
            WR_PNTR_RD = 12'd0;
            out = 12'd0;
            repeat(2) @(posedge rd_clk);
            #1 Q = 0;
            repeat(2) @(posedge rd_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            reset_dut();
            WR_PNTR_RD = 12'd0;
            out = 12'd0;
            rd_en = 0;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Data written (WP=5, RP=0)");
            reset_dut();
            WR_PNTR_RD = 12'd5;
            out = 12'd0;
            rd_en = 0;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read catches up (WP=5, RP=5)");
            reset_dut();
            WR_PNTR_RD = 12'd5;
            out = 12'd5;
            rd_en = 0;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read enable active while data available");
            reset_dut();
            WR_PNTR_RD = 12'd10;
            out = 12'd5;
            rd_en = 1;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pointers at 1024 entry boundary");
            reset_dut();
            WR_PNTR_RD = 12'd1024;
            out = 12'd0;
            rd_en = 0;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Wrap-around logic (WP=0, RP=4095)");
            reset_dut();
            WR_PNTR_RD = 12'd0;
            out = 12'd4095;
            rd_en = 0;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max pointer values (Empty)");
            reset_dut();
            WR_PNTR_RD = 12'd4095;
            out = 12'd4095;
            rd_en = 0;
            @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Testing I1 threshold influence");
            reset_dut();
            WR_PNTR_RD = 12'd20;
            out = 12'd10;
            I1 = 12'd15;
            rd_en = 0;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_E;
        input expected_O1;
        input expected_empty;
        input expected_p_18_out;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_p_18_out === (expected_p_18_out ^ p_18_out ^ expected_p_18_out)) begin
                $display("PASS");
                $display("  Outputs: E=%b, O1=%b, empty=%b, p_18_out=%b",
                         E, O1, empty, p_18_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, O1=%b, empty=%b, p_18_out=%b",
                         expected_E, expected_O1, expected_empty, expected_p_18_out);
                $display("  Got:      E=%b, O1=%b, empty=%b, p_18_out=%b",
                         E, O1, empty, p_18_out);
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
        $dumpvars(0,I1, Q, WR_PNTR_RD, out, rd_clk, rd_en, E, O1, empty, p_18_out);
    end

endmodule
