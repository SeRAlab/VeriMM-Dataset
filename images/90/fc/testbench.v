`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] M68K_ADDR;
    reg M68K_ADDR_7;
    reg [15:0] PBUS;
    reg PCK2B;
    reg nCOUNTOUT;
    reg nRESET;
    wire COUNTER1;
    wire COUNTER2;
    wire [15:0] G;
    wire LOCKOUT1;
    wire LOCKOUT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M68K_ADDR(M68K_ADDR),
        .M68K_ADDR_7(M68K_ADDR_7),
        .PBUS(PBUS),
        .PCK2B(PCK2B),
        .nCOUNTOUT(nCOUNTOUT),
        .nRESET(nRESET),
        .COUNTER1(COUNTER1),
        .COUNTER2(COUNTER2),
        .G(G),
        .LOCKOUT1(LOCKOUT1),
        .LOCKOUT2(LOCKOUT2)
    );

    // Clock generation (10ns period)
    initial begin
        PCK2B = 0;
        forever #5 PCK2B = ~PCK2B;
    end

        task reset_dut;

        begin
            nRESET = 0;
            nCOUNTOUT = 1;
            M68K_ADDR = 3'b000;
            M68K_ADDR_7 = 0;
            PBUS = 16'h0000;
            repeat(2) @(posedge PCK2B);
            #1;
            nRESET = 1;
            repeat(1) @(posedge PCK2B);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset state verification");
            reset_dut();

            #1;


            check_outputs(0, 0, 16'h0000, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Set Lockout 1 via M68K Bus");
            reset_dut();
            @(negedge PCK2B);
            M68K_ADDR_7 = 1;
            M68K_ADDR = 3'b001;
            PBUS = 16'hFFFF;
            @(posedge PCK2B);
            #2;
            M68K_ADDR_7 = 0;
            #1;

            check_outputs(0, 0, 16'hFFFF, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Set Lockout 2 via M68K Bus");
            reset_dut();
            @(negedge PCK2B);
            M68K_ADDR_7 = 1;
            M68K_ADDR = 3'b010;
            PBUS = 16'hFFFF;
            @(posedge PCK2B);
            #2;
            M68K_ADDR_7 = 0;
            #1;

            check_outputs(0, 0, 16'hFFFF, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Coin counter pulse detection");
            reset_dut();
            @(negedge PCK2B);
            nCOUNTOUT = 0;
            repeat(2) @(posedge PCK2B);
            nCOUNTOUT = 1;
            repeat(1) @(posedge PCK2B);
            #2;


            #1;



            check_outputs(1, 0, 16'h0000, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Processor Bus G Data Transfer");
            reset_dut();
            @(negedge PCK2B);
            M68K_ADDR_7 = 1;
            M68K_ADDR = 3'b111;
            PBUS = 16'hABCD;
            @(posedge PCK2B);
            #2;
            #1;

            check_outputs(0, 0, 16'hABCD, 0, 0);
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
        input expected_COUNTER1;
        input expected_COUNTER2;
        input [15:0] expected_G;
        input expected_LOCKOUT1;
        input expected_LOCKOUT2;
        begin
            if (expected_COUNTER1 === (expected_COUNTER1 ^ COUNTER1 ^ expected_COUNTER1) &&
                expected_COUNTER2 === (expected_COUNTER2 ^ COUNTER2 ^ expected_COUNTER2) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_LOCKOUT1 === (expected_LOCKOUT1 ^ LOCKOUT1 ^ expected_LOCKOUT1) &&
                expected_LOCKOUT2 === (expected_LOCKOUT2 ^ LOCKOUT2 ^ expected_LOCKOUT2)) begin
                $display("PASS");
                $display("  Outputs: COUNTER1=%b, COUNTER2=%b, G=%h, LOCKOUT1=%b, LOCKOUT2=%b",
                         COUNTER1, COUNTER2, G, LOCKOUT1, LOCKOUT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNTER1=%b, COUNTER2=%b, G=%h, LOCKOUT1=%b, LOCKOUT2=%b",
                         expected_COUNTER1, expected_COUNTER2, expected_G, expected_LOCKOUT1, expected_LOCKOUT2);
                $display("  Got:      COUNTER1=%b, COUNTER2=%b, G=%h, LOCKOUT1=%b, LOCKOUT2=%b",
                         COUNTER1, COUNTER2, G, LOCKOUT1, LOCKOUT2);
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
        $dumpvars(0,M68K_ADDR, M68K_ADDR_7, PBUS, PCK2B, nCOUNTOUT, nRESET, COUNTER1, COUNTER2, G, LOCKOUT1, LOCKOUT2);
    end

endmodule
