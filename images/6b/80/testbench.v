`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] BNK;
    reg [22:0] M68K_ADDR;
    reg nSROMOEL;
    reg nSROMOEU;
    reg nVEC;
    wire A22Z;
    wire A23Z;
    wire [23:0] CDA;
    wire nSROMOE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BNK(BNK),
        .M68K_ADDR(M68K_ADDR),
        .nSROMOEL(nSROMOEL),
        .nSROMOEU(nSROMOEU),
        .nVEC(nVEC),
        .A22Z(A22Z),
        .A23Z(A23Z),
        .CDA(CDA),
        .nSROMOE(nSROMOE)
    );
    task reset_inputs;

    begin
        BNK = 3'b000;
        M68K_ADDR = 23'h0;
        nSROMOEL = 1'b1;
        nSROMOEU = 1'b1;
        nVEC = 1'b1;
        #5;
    end
        endtask

    task testcase001;

    begin
        reset_inputs();
        test_num = 1;
        nSROMOEU = 0; nSROMOEL = 0;
        #1;

        check_outputs(0, 0, 24'h000000, 0);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        test_num = 2;
        nSROMOEU = 1; nSROMOEL = 0;

        #1;


        check_outputs(0, 0, 24'h000000, 0);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        test_num = 3;
        nSROMOEU = 1; nSROMOEL = 1;
        #1;

        check_outputs(0, 0, 24'h000000, 1);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        test_num = 4;
        nVEC = 1;

        M68K_ADDR = 23'h600000;
        #1;

        check_outputs(1, 1, 24'h000000, 1);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        test_num = 5;
        nVEC = 0;
        M68K_ADDR = 23'h600000;

        #1;


        check_outputs(0, 0, 24'h000000, 1);
    end
        endtask

    task testcase006;

    begin
        reset_inputs();
        test_num = 6;
        BNK = 3'b101;
        M68K_ADDR = 23'h00000F;


        #1;



        check_outputs(0, 0, 24'hA0001E, 1);
    end
        endtask

    task testcase007;

    begin
        reset_inputs();
        test_num = 7;
        BNK = 3'b111;
        M68K_ADDR = 23'h1FFFFF;

        #1;


        check_outputs(1, 1, 24'hFFFFFE, 1);
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
        input expected_A22Z;
        input expected_A23Z;
        input [23:0] expected_CDA;
        input expected_nSROMOE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A22Z === (expected_A22Z ^ A22Z ^ expected_A22Z) &&
                expected_A23Z === (expected_A23Z ^ A23Z ^ expected_A23Z) &&
                expected_CDA === (expected_CDA ^ CDA ^ expected_CDA) &&
                expected_nSROMOE === (expected_nSROMOE ^ nSROMOE ^ expected_nSROMOE)) begin
                $display("PASS");
                $display("  Outputs: A22Z=%b, A23Z=%b, CDA=%h, nSROMOE=%b",
                         A22Z, A23Z, CDA, nSROMOE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A22Z=%b, A23Z=%b, CDA=%h, nSROMOE=%b",
                         expected_A22Z, expected_A23Z, expected_CDA, expected_nSROMOE);
                $display("  Got:      A22Z=%b, A23Z=%b, CDA=%h, nSROMOE=%b",
                         A22Z, A23Z, CDA, nSROMOE);
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

endmodule
