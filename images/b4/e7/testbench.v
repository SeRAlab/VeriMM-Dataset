`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] CcountH;
    reg [7:0] CcountM;
    reg [7:0] CcountS;
    reg [7:0] CprogH;
    reg [7:0] CprogM;
    reg [7:0] CprogS;
    reg clock;
    reg en;
    reg reset;
    wire fin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CcountH(CcountH),
        .CcountM(CcountM),
        .CcountS(CcountS),
        .CprogH(CprogH),
        .CprogM(CprogM),
        .CprogS(CprogS),
        .clock(clock),
        .en(en),
        .reset(reset),
        .fin(fin)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            CcountH = 0; CcountM = 0; CcountS = 0;
            CprogH = 0; CprogM = 0; CprogS = 0;
            @(posedge clock);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            CprogH = 8'h12; CprogM = 8'h34; CprogS = 8'h56;
            CcountH = 8'h12; CcountM = 8'h34; CcountS = 8'h56;
            en = 1;
            @(posedge clock);
            #1;
            $display("Testcase 001: Match non-zero components");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            CprogH = 8'h00; CprogM = 8'h00; CprogS = 8'h00;
            CcountH = 8'h00; CcountM = 8'h00; CcountS = 8'h00;
            en = 1;
            @(posedge clock);
            #1;
            $display("Testcase 002: Match but components are zero");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            CprogH = 8'hAA; CprogM = 8'hBB; CprogS = 8'hCC;
            CcountH = 8'hA1; CcountM = 8'hBB; CcountS = 8'hCC;
            en = 1;
            @(posedge clock);
            #1;
            $display("Testcase 003: Mismatch in High component");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            CprogH = 8'hAA; CprogM = 8'hBB; CprogS = 8'hCC;
            CcountH = 8'hAA; CcountM = 8'hB1; CcountS = 8'hCC;
            en = 1;
            @(posedge clock);
            #1;
            $display("Testcase 004: Mismatch in Medium component");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            CprogH = 8'hAA; CprogM = 8'hBB; CprogS = 8'hCC;
            CcountH = 8'hAA; CcountM = 8'hBB; CcountS = 8'hC1;
            en = 1;
            @(posedge clock);
            #1;
            $display("Testcase 005: Mismatch in Low component");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            CprogH = 8'hFF; CprogM = 8'hFF; CprogS = 8'hFF;
            CcountH = 8'hFF; CcountM = 8'hFF; CcountS = 8'hFF;
            en = 0;
            @(posedge clock);
            #1;
            $display("Testcase 006: Components match but en is 0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            CprogH = 8'h11; CprogM = 8'h22; CprogS = 8'h33;
            CcountH = 8'h11; CcountM = 8'h22; CcountS = 8'h33;
            en = 1;
            reset = 1;
            @(posedge clock);
            #1;
            $display("Testcase 007: Match and en active, but reset high");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            CprogH = 8'h00; CprogM = 8'h00; CprogS = 8'h01;
            CcountH = 8'h00; CcountM = 8'h00; CcountS = 8'h01;
            en = 1;
            @(posedge clock);
            #1;
            $display("Testcase 008: Only 'S' component non-zero and matching");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();

            CprogH = 8'h10; CprogM = 8'h10; CprogS = 8'h10;
            CcountH = 8'h10; CcountM = 8'h10; CcountS = 8'h10;
            en = 1;
            @(posedge clock);
            #1;

            CcountS = 8'h00;
            @(posedge clock);
            #1;
            $display("Testcase 009: Transition from match to mismatch");
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
        testcase009();
        
        
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
        input expected_fin;
        begin
            if (expected_fin === (expected_fin ^ fin ^ expected_fin)) begin
                $display("PASS");
                $display("  Outputs: fin=%b",
                         fin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fin=%b",
                         expected_fin);
                $display("  Got:      fin=%b",
                         fin);
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
        $dumpvars(0,CcountH, CcountM, CcountS, CprogH, CprogM, CprogS, clock, en, reset, fin);
    end

endmodule
