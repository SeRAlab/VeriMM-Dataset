`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] BranchAdd;
    reg [31:0] PCplus4;
    wire [31:0] EXE_BranchAddress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BranchAdd(BranchAdd),
        .PCplus4(PCplus4),
        .EXE_BranchAddress(EXE_BranchAddress)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Addition", test_num);
            PCplus4 = 32'h00000004;
            BranchAdd = 32'h00000008;
            #1;

            check_outputs(32'h0000000C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Offset", test_num);
            PCplus4 = 32'h00001000;
            BranchAdd = 32'h00000000;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Offset (Backward Branch)", test_num);

            PCplus4 = 32'h00001004;
            BranchAdd = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Positive Offset", test_num);
            PCplus4 = 32'h10000000;
            BranchAdd = 32'h0000FFFF;
            #1;

            check_outputs(32'h1000FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrap Around (Upper Boundary)", test_num);
            PCplus4 = 32'hFFFFFFFC;
            BranchAdd = 32'h00000008;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            PCplus4 = 32'hFFFFFFFF;
            BranchAdd = 32'hFFFFFFFF;

            #1;


            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Negative Offset", test_num);
            PCplus4 = 32'h00000010;
            BranchAdd = 32'hFFFFF000;
            #1;

            check_outputs(32'hFFFFF010);
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
        input [31:0] expected_EXE_BranchAddress;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EXE_BranchAddress === (expected_EXE_BranchAddress ^ EXE_BranchAddress ^ expected_EXE_BranchAddress)) begin
                $display("PASS");
                $display("  Outputs: EXE_BranchAddress=%h",
                         EXE_BranchAddress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXE_BranchAddress=%h",
                         expected_EXE_BranchAddress);
                $display("  Got:      EXE_BranchAddress=%h",
                         EXE_BranchAddress);
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
