`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUSrcB;
    reg [31:0] B;
    reg [31:0] DestBranch;
    reg [31:0] Immediate;
    reg [31:0] ImmediateUns;
    wire [31:0] MuxOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrcB(ALUSrcB),
        .B(B),
        .DestBranch(DestBranch),
        .Immediate(Immediate),
        .ImmediateUns(ImmediateUns),
        .MuxOut(MuxOut)
    );
    task testcase001;

        begin
            test_num = 1;
            B = 32'hABCD_EF01;
            Immediate = 32'h0;
            DestBranch = 32'h0;
            ImmediateUns = 32'h0;
            ALUSrcB = 3'd0;
            $display("Test %0d: Select B", test_num);
            #1;

            check_outputs(32'hABCD_EF01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            B = 32'hFFFF_FFFF;
            ALUSrcB = 3'd1;
            $display("Test %0d: Select Constant 4", test_num);
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Immediate = 32'h1234_5678;
            ALUSrcB = 3'd2;
            $display("Test %0d: Select Immediate", test_num);
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            DestBranch = 32'h55AA_CC33;
            ALUSrcB = 3'd3;
            $display("Test %0d: Select DestBranch", test_num);
            #1;

            check_outputs(32'h55AA_CC33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ImmediateUns = 32'h0000_FFFF;
            ALUSrcB = 3'd4;
            $display("Test %0d: Select ImmediateUns", test_num);
            #1;

            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ALUSrcB = 3'd0;
            B = 32'h1111_2222;
            #5;
            B = 32'h3333_4444;
            $display("Test %0d: Dynamic Input B change", test_num);
            #1;

            check_outputs(32'h3333_4444);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Immediate = 32'hAAAA_AAAA;
            ImmediateUns = 32'hBBBB_BBBB;
            ALUSrcB = 3'd2;
            #5;
            ALUSrcB = 3'd4;
            $display("Test %0d: Switch Select from 2 to 4", test_num);
            #1;

            check_outputs(32'hBBBB_BBBB);
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
        input [31:0] expected_MuxOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MuxOut === (expected_MuxOut ^ MuxOut ^ expected_MuxOut)) begin
                $display("PASS");
                $display("  Outputs: MuxOut=%h",
                         MuxOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MuxOut=%h",
                         expected_MuxOut);
                $display("  Got:      MuxOut=%h",
                         MuxOut);
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
