`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] SBADRI;
    reg SBCLKI;
    reg [7:0] SBDATI;
    reg SBRWI;
    reg SBSTBI;
    wire I2CIRQ;
    wire I2CWKUP;
    wire SBACKO;
    wire [7:0] SBDATO;
    wire SCLO;
    wire SCLOE;
    wire SDAO;
    wire SDAOE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SBADRI(SBADRI),
        .SBCLKI(SBCLKI),
        .SBDATI(SBDATI),
        .SBRWI(SBRWI),
        .SBSTBI(SBSTBI),
        .I2CIRQ(I2CIRQ),
        .I2CWKUP(I2CWKUP),
        .SBACKO(SBACKO),
        .SBDATO(SBDATO),
        .SCLO(SCLO),
        .SCLOE(SCLOE),
        .SDAO(SDAO),
        .SDAOE(SDAOE)
    );

    // Clock generation (10ns period)
    initial begin
        SBCLKI = 0;
        forever #5 SBCLKI = ~SBCLKI;
    end

        task reset_dut;

        begin
            SBSTBI = 0;
            SBADRI = 8'h00;
            SBDATI = 8'h00;
            SBRWI  = 0;
            repeat (2) @(posedge SBCLKI);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 8'h00, 1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge SBCLKI);
            SBADRI = 8'h01;
            SBDATI = 8'hAA;
            SBRWI  = 0;
            SBSTBI = 1;
            @(posedge SBCLKI);

            #1;


            check_outputs(0, 0, 1, 8'h00, 1, 0, 1, 0);
            SBSTBI = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge SBCLKI);
            SBADRI = 8'h01;
            SBRWI  = 1;
            SBSTBI = 1;
            @(posedge SBCLKI);

            #1;


            check_outputs(0, 0, 1, 8'h00, 1, 0, 1, 0);
            SBSTBI = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge SBCLKI);
            SBADRI = 8'hFF;
            SBSTBI = 1;
            @(posedge SBCLKI);

            #1;


            check_outputs(0, 0, 0, 8'h00, 1, 0, 1, 0);
            SBSTBI = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge SBCLKI);
            SBADRI = 8'h02;
            SBDATI = 8'h01;
            SBRWI  = 0;
            SBSTBI = 1;
            @(posedge SBCLKI);
            SBSTBI = 0;
            repeat(2) @(posedge SBCLKI);


            #1;



            check_outputs(0, 0, 0, 8'h00, 1, 0, 1, 0);
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
        input expected_I2CIRQ;
        input expected_I2CWKUP;
        input expected_SBACKO;
        input [7:0] expected_SBDATO;
        input expected_SCLO;
        input expected_SCLOE;
        input expected_SDAO;
        input expected_SDAOE;
        begin
            if (expected_I2CIRQ === (expected_I2CIRQ ^ I2CIRQ ^ expected_I2CIRQ) &&
                expected_I2CWKUP === (expected_I2CWKUP ^ I2CWKUP ^ expected_I2CWKUP) &&
                expected_SBACKO === (expected_SBACKO ^ SBACKO ^ expected_SBACKO) &&
                expected_SBDATO === (expected_SBDATO ^ SBDATO ^ expected_SBDATO) &&
                expected_SCLO === (expected_SCLO ^ SCLO ^ expected_SCLO) &&
                expected_SCLOE === (expected_SCLOE ^ SCLOE ^ expected_SCLOE) &&
                expected_SDAO === (expected_SDAO ^ SDAO ^ expected_SDAO) &&
                expected_SDAOE === (expected_SDAOE ^ SDAOE ^ expected_SDAOE)) begin
                $display("PASS");
                $display("  Outputs: I2CIRQ=%b, I2CWKUP=%b, SBACKO=%b, SBDATO=%h, SCLO=%b, SCLOE=%b, SDAO=%b, SDAOE=%b",
                         I2CIRQ, I2CWKUP, SBACKO, SBDATO, SCLO, SCLOE, SDAO, SDAOE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I2CIRQ=%b, I2CWKUP=%b, SBACKO=%b, SBDATO=%h, SCLO=%b, SCLOE=%b, SDAO=%b, SDAOE=%b",
                         expected_I2CIRQ, expected_I2CWKUP, expected_SBACKO, expected_SBDATO, expected_SCLO, expected_SCLOE, expected_SDAO, expected_SDAOE);
                $display("  Got:      I2CIRQ=%b, I2CWKUP=%b, SBACKO=%b, SBDATO=%h, SCLO=%b, SCLOE=%b, SDAO=%b, SDAOE=%b",
                         I2CIRQ, I2CWKUP, SBACKO, SBDATO, SCLO, SCLOE, SDAO, SDAOE);
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
        $dumpvars(0,SBADRI, SBCLKI, SBDATI, SBRWI, SBSTBI, I2CIRQ, I2CWKUP, SBACKO, SBDATO, SCLO, SCLOE, SDAO, SDAOE);
    end

endmodule
