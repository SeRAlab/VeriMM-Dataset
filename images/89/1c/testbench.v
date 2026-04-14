`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] BFN;
    wire [31:0] BOOLO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .BFN(BFN),
        .BOOLO(BOOLO)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND (BFN=0)", test_num);

        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;

        A = 32'hAAAA_5555;
        B = 32'hFFFF_0000;
        BFN = 4'd0;
        #5;
        #1;

        check_outputs(32'hAAAA_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR (BFN=1)", test_num);
        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;
        A = 32'h1234_0000;
        B = 32'h0000_5678;
        BFN = 4'd1;
        #5;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR (BFN=2)", test_num);
        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;
        A = 32'hFFFF_FFFF;
        B = 32'h1234_5678;
        BFN = 4'd2;
        #5;
        #1;

        check_outputs(32'hEDCB_A987);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Buffer A (BFN=3)", test_num);
        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;
        A = 32'hDEAD_BEEF;
        B = 32'hFFFF_FFFF;
        BFN = 4'd3;
        #5;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Undefined BFN (BFN=7)", test_num);
        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        BFN = 4'h7;
        #5;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND with zero", test_num);
        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        BFN = 4'd0;
        #5;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XOR same values", test_num);
        A = 32'h0; B = 32'h0; BFN = 4'h0;
        #5;
        A = 32'hA5A5_A5A5;
        B = 32'hA5A5_A5A5;
        BFN = 4'd2;
        #5;
        #1;

        check_outputs(32'h0000_0000);
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
        input [31:0] expected_BOOLO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BOOLO === (expected_BOOLO ^ BOOLO ^ expected_BOOLO)) begin
                $display("PASS");
                $display("  Outputs: BOOLO=%h",
                         BOOLO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BOOLO=%h",
                         expected_BOOLO);
                $display("  Got:      BOOLO=%h",
                         BOOLO);
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
