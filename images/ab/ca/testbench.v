`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [31:0] D;
    reg E;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .E(E),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            E = 0;
            D = 0;
            @(posedge CLK);
            #1;
            CLR = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            E = 1;
            D = 32'hAAAAAAAA;
            @(posedge CLK);
            #1;
            CLR = 1;
            @(posedge CLK);
            #1;
            CLR = 0;
            $display("Testcase 001: Clear functionality");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            E = 1;
            D = 32'h12345678;
            @(posedge CLK);
            #1;
            $display("Testcase 002: Enable and Load (32'h12345678)");
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            E = 1;
            D = 32'hDEADBEEF;
            @(posedge CLK);
            #1;

            E = 0;
            D = 32'hCAFEBABE;
            @(posedge CLK);
            #1;
            $display("Testcase 003: Hold functionality (Enable=0)");
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            E = 1;
            CLR = 1;
            D = 32'hFFFFFFFF;
            @(posedge CLK);
            #1;
            $display("Testcase 004: Priority Check (CLR high, E high)");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            E = 1;
            D = 32'hFFFFFFFF;
            @(posedge CLK);
            #1;
            $display("Testcase 005: Boundary Value (All 1s)");
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            E = 1;
            D = 32'h5555AAAA;
            @(posedge CLK);
            #1;
            $display("Testcase 006: Bit pattern (5555AAAA)");
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            E = 1;
            D = 32'hBCBCBCBC;
            @(posedge CLK);
            #1;
            E = 0;
            D = 32'h0;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #1;
            $display("Testcase 007: Retain value over multiple clock cycles");
            #1;

            check_outputs(32'hBCBCBCBC);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, CLR, D, E, Q);
    end

endmodule
