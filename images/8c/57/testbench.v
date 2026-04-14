`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg Sdat;
    reg Trailer_OLD_NEW_0_1;
    wire ROC_HEADER;
    wire TBM_HEADER;
    wire TBM_TRAILER;
    wire gate;
    wire sdo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Sdat(Sdat),
        .Trailer_OLD_NEW_0_1(Trailer_OLD_NEW_0_1),
        .ROC_HEADER(ROC_HEADER),
        .TBM_HEADER(TBM_HEADER),
        .TBM_TRAILER(TBM_TRAILER),
        .gate(gate),
        .sdo(sdo)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            Sdat = 0;
            Trailer_OLD_NEW_0_1 = 0;
            repeat (20) @(posedge CLK);
            #1;
        end
        endtask
    task send_pattern;

        input [11:0] pattern;
        integer i;
        begin
            for (i = 11; i >= 0; i = i - 1) begin
                Sdat = pattern[i];
                @(posedge CLK);
            end
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: TBM Header Detection");
            reset_dut();
            send_pattern(12'b111111111100);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: ROC Header Detection");
            reset_dut();
            send_pattern(12'b111111111101);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: TBM Trailer Detection");
            reset_dut();

            send_pattern(12'b111111111100);

            send_pattern(12'b111111111110);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Gate persistence after Header");
            reset_dut();
            send_pattern(12'b111111111100);

            repeat (10) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Serial Data Out (sdo) Check");
            reset_dut();
            Sdat = 1; @(posedge CLK);
            Sdat = 0; @(posedge CLK);
            Sdat = 1; @(posedge CLK);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input expected_ROC_HEADER;
        input expected_TBM_HEADER;
        input expected_TBM_TRAILER;
        input expected_gate;
        input expected_sdo;
        begin
            if (expected_ROC_HEADER === (expected_ROC_HEADER ^ ROC_HEADER ^ expected_ROC_HEADER) &&
                expected_TBM_HEADER === (expected_TBM_HEADER ^ TBM_HEADER ^ expected_TBM_HEADER) &&
                expected_TBM_TRAILER === (expected_TBM_TRAILER ^ TBM_TRAILER ^ expected_TBM_TRAILER) &&
                expected_gate === (expected_gate ^ gate ^ expected_gate) &&
                expected_sdo === (expected_sdo ^ sdo ^ expected_sdo)) begin
                $display("PASS");
                $display("  Outputs: ROC_HEADER=%b, TBM_HEADER=%b, TBM_TRAILER=%b, gate=%b, sdo=%b",
                         ROC_HEADER, TBM_HEADER, TBM_TRAILER, gate, sdo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ROC_HEADER=%b, TBM_HEADER=%b, TBM_TRAILER=%b, gate=%b, sdo=%b",
                         expected_ROC_HEADER, expected_TBM_HEADER, expected_TBM_TRAILER, expected_gate, expected_sdo);
                $display("  Got:      ROC_HEADER=%b, TBM_HEADER=%b, TBM_TRAILER=%b, gate=%b, sdo=%b",
                         ROC_HEADER, TBM_HEADER, TBM_TRAILER, gate, sdo);
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
        $dumpvars(0,CLK, Sdat, Trailer_OLD_NEW_0_1, ROC_HEADER, TBM_HEADER, TBM_TRAILER, gate, sdo);
    end

endmodule
