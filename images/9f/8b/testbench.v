`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg q0;
    reg start;
    wire CargaA;
    wire CargaQ;
    wire DesplazaQ;
    wire Fin;
    wire ResetA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .q0(q0),
        .start(start),
        .CargaA(CargaA),
        .CargaQ(CargaQ),
        .DesplazaQ(DesplazaQ),
        .Fin(Fin),
        .ResetA(ResetA)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            q0 = 0;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State S0");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 1, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: State S1 with q0=1");
            test_num = 2;
            reset_dut();
            q0 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: State S1 with q0=0");
            test_num = 3;
            reset_dut();
            q0 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: State S2");
            test_num = 4;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: State S3 with q0=1");
            test_num = 5;
            reset_dut();
            q0 = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: State S4");
            test_num = 6;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: State S5 with q0=1");
            test_num = 7;
            reset_dut();
            q0 = 1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: State S6 (Fin)");
            test_num = 8;
            reset_dut();
            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1, 0);
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
        input expected_CargaA;
        input expected_CargaQ;
        input expected_DesplazaQ;
        input expected_Fin;
        input expected_ResetA;
        begin
            if (expected_CargaA === (expected_CargaA ^ CargaA ^ expected_CargaA) &&
                expected_CargaQ === (expected_CargaQ ^ CargaQ ^ expected_CargaQ) &&
                expected_DesplazaQ === (expected_DesplazaQ ^ DesplazaQ ^ expected_DesplazaQ) &&
                expected_Fin === (expected_Fin ^ Fin ^ expected_Fin) &&
                expected_ResetA === (expected_ResetA ^ ResetA ^ expected_ResetA)) begin
                $display("PASS");
                $display("  Outputs: CargaA=%b, CargaQ=%b, DesplazaQ=%b, Fin=%b, ResetA=%b",
                         CargaA, CargaQ, DesplazaQ, Fin, ResetA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CargaA=%b, CargaQ=%b, DesplazaQ=%b, Fin=%b, ResetA=%b",
                         expected_CargaA, expected_CargaQ, expected_DesplazaQ, expected_Fin, expected_ResetA);
                $display("  Got:      CargaA=%b, CargaQ=%b, DesplazaQ=%b, Fin=%b, ResetA=%b",
                         CargaA, CargaQ, DesplazaQ, Fin, ResetA);
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
        $dumpvars(0,clk, q0, start, CargaA, CargaQ, DesplazaQ, Fin, ResetA);
    end

endmodule
