`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR_n;
    reg [3:0] D;
    reg ENP;
    reg ENT;
    reg LOAD_n;
    wire [3:0] Q;
    wire RCO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR_n(CLR_n),
        .D(D),
        .ENP(ENP),
        .ENT(ENT),
        .LOAD_n(LOAD_n),
        .Q(Q),
        .RCO(RCO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR_n = 0;
            LOAD_n = 1;
            ENP = 0;
            ENT = 0;
            D = 4'b0000;
            @(posedge CLK);
            #1;
            CLR_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Synchronous Clear Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Synchronous Load Check");
            test_num = 2;
            reset_dut();
            D = 4'hA;
            LOAD_n = 0;
            @(posedge CLK);
            #1;
            LOAD_n = 1;
            #1;

            check_outputs(4'hA, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Counting to 5");
            test_num = 3;
            reset_dut();
            ENP = 1;
            ENT = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h5, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: ENP Inhibit Count");
            test_num = 4;
            reset_dut();
            D = 4'h7; LOAD_n = 0; @(posedge CLK); #1;
            LOAD_n = 1; ENP = 0; ENT = 1;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h7, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: ENT Inhibit Count and RCO");
            test_num = 5;
            reset_dut();
            D = 4'hF; LOAD_n = 0; @(posedge CLK); #1;
            LOAD_n = 1; ENP = 1; ENT = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hF, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: RCO at Max Value");
            test_num = 6;
            reset_dut();
            D = 4'hF; LOAD_n = 0; @(posedge CLK); #1;
            LOAD_n = 1; ENP = 1; ENT = 1;
            #1;

            check_outputs(4'hF, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Wrap around (15->0)");
            test_num = 7;
            reset_dut();
            D = 4'hF; LOAD_n = 0; @(posedge CLK); #1;
            LOAD_n = 1; ENP = 1; ENT = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Clear Priority over Load");
            test_num = 8;
            reset_dut();
            CLR_n = 0; LOAD_n = 0; D = 4'h5;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h0, 0);
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
        input [3:0] expected_Q;
        input expected_RCO;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_RCO === (expected_RCO ^ RCO ^ expected_RCO)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, RCO=%b",
                         Q, RCO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, RCO=%b",
                         expected_Q, expected_RCO);
                $display("  Got:      Q=%h, RCO=%b",
                         Q, RCO);
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
        $dumpvars(0,CLK, CLR_n, D, ENP, ENT, LOAD_n, Q, RCO);
    end

endmodule
