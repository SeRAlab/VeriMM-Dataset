`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUZero;
    reg Branch;
    reg [63:0] CurrentPC;
    reg [63:0] SignExtImm64;
    reg Uncondbranch;
    wire [63:0] NextPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUZero(ALUZero),
        .Branch(Branch),
        .CurrentPC(CurrentPC),
        .SignExtImm64(SignExtImm64),
        .Uncondbranch(Uncondbranch),
        .NextPC(NextPC)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Normal Sequential Increment", test_num);
            CurrentPC = 64'h0000_0000_0000_0100;
            SignExtImm64 = 64'h0000_0000_0000_0005;
            Branch = 0;
            ALUZero = 0;
            Uncondbranch = 0;
            #1;

            check_outputs(64'h0000_0000_0000_0104);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Conditional Branch Taken (ALUZero=1)", test_num);
            CurrentPC = 64'h0000_0000_0000_1000;
            SignExtImm64 = 64'h0000_0000_0000_0008;
            Branch = 1;
            ALUZero = 1;
            Uncondbranch = 0;
            #1;

            check_outputs(64'h0000_0000_0000_1020);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Conditional Branch Not Taken (ALUZero=0)", test_num);
            CurrentPC = 64'h0000_0000_0000_2000;
            SignExtImm64 = 64'h0000_0000_0000_000A;
            Branch = 1;
            ALUZero = 0;
            Uncondbranch = 0;
            #1;

            check_outputs(64'h0000_0000_0000_2004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Unconditional Branch", test_num);
            CurrentPC = 64'h0000_0000_0000_3000;
            SignExtImm64 = 64'h0000_0000_0000_0004;
            Branch = 0;
            ALUZero = 0;
            Uncondbranch = 1;
            #1;

            check_outputs(64'h0000_0000_0000_3010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Backward Branch (Negative Offset)", test_num);
            CurrentPC = 64'h0000_0000_0000_4000;

            SignExtImm64 = 64'hFFFF_FFFF_FFFF_FFFC;
            Branch = 1;
            ALUZero = 1;
            Uncondbranch = 0;

            #1;


            check_outputs(64'h0000_0000_0000_3FF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Unconditional Priority Check", test_num);
            CurrentPC = 64'h0000_0000_0000_5000;
            SignExtImm64 = 64'h0000_0000_0000_0002;
            Branch = 1;
            ALUZero = 0;
            Uncondbranch = 1;
            #1;

            check_outputs(64'h0000_0000_0000_5008);
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
        input [63:0] expected_NextPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NextPC === (expected_NextPC ^ NextPC ^ expected_NextPC)) begin
                $display("PASS");
                $display("  Outputs: NextPC=%h",
                         NextPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NextPC=%h",
                         expected_NextPC);
                $display("  Got:      NextPC=%h",
                         NextPC);
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
