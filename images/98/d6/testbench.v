`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A_DATA;
    reg [31:0] B_DATA;
    reg MA;
    reg MB;
    reg [31:0] PC_M1;
    reg [31:0] SEorZF;
    wire [31:0] BUS_A;
    wire [31:0] BUS_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_DATA(A_DATA),
        .B_DATA(B_DATA),
        .MA(MA),
        .MB(MB),
        .PC_M1(PC_M1),
        .SEorZF(SEorZF),
        .BUS_A(BUS_A),
        .BUS_B(BUS_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select A_DATA and B_DATA (MA=0, MB=0)", test_num);
            PC_M1  = 32'h1111_1111;
            A_DATA = 32'hAAAA_AAAA;
            B_DATA = 32'hBBBB_BBBB;
            SEorZF = 32'h2222_2222;
            MA     = 1'b0;
            MB     = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select PC_M1 and SEorZF (MA=1, MB=1)", test_num);
            PC_M1  = 32'h1111_1111;
            A_DATA = 32'hAAAA_AAAA;
            B_DATA = 32'hBBBB_BBBB;
            SEorZF = 32'h2222_2222;
            MA     = 1'b1;
            MB     = 1'b1;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed selection (MA=1, MB=0)", test_num);
            PC_M1  = 32'hCAFE_BABE;
            A_DATA = 32'h0000_0000;
            B_DATA = 32'h5555_5555;
            SEorZF = 32'hFFFF_FFFF;
            MA     = 1'b1;
            MB     = 1'b0;
            #1;

            check_outputs(32'hCAFE_BABE, 32'h5555_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed selection (MA=0, MB=1)", test_num);
            PC_M1  = 32'hCAFE_BABE;
            A_DATA = 32'h0000_0000;
            B_DATA = 32'h5555_5555;
            SEorZF = 32'hFFFF_FFFF;
            MA     = 1'b0;
            MB     = 1'b1;
            #1;

            check_outputs(32'h0000_0000, 32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs identical value check", test_num);
            PC_M1  = 32'h1234_5678;
            A_DATA = 32'h1234_5678;
            B_DATA = 32'h1234_5678;
            SEorZF = 32'h1234_5678;
            MA     = 1'b1;
            MB     = 1'b0;
            #1;

            check_outputs(32'h1234_5678, 32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large numbers selection check", test_num);
            PC_M1  = 32'h8765_4321;
            A_DATA = 32'hFEDC_BA98;
            B_DATA = 32'h7654_3210;
            SEorZF = 32'h0FED_CBA9;
            MA     = 1'b0;
            MB     = 1'b1;
            #1;

            check_outputs(32'hFEDC_BA98, 32'h0FED_CBA9);
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
        input [31:0] expected_BUS_A;
        input [31:0] expected_BUS_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BUS_A === (expected_BUS_A ^ BUS_A ^ expected_BUS_A) &&
                expected_BUS_B === (expected_BUS_B ^ BUS_B ^ expected_BUS_B)) begin
                $display("PASS");
                $display("  Outputs: BUS_A=%h, BUS_B=%h",
                         BUS_A, BUS_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUS_A=%h, BUS_B=%h",
                         expected_BUS_A, expected_BUS_B);
                $display("  Got:      BUS_A=%h, BUS_B=%h",
                         BUS_A, BUS_B);
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
