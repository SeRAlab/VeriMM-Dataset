`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] PCPlus1;
    reg [15:0] SignImm;
    wire [15:0] PCBranch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCPlus1(PCPlus1),
        .SignImm(SignImm),
        .PCBranch(PCBranch)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PCPlus1=0, SignImm=0", test_num);
            PCPlus1 = 16'h0000;
            SignImm = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small positive offset", test_num);
            PCPlus1 = 16'h0005;
            SignImm = 16'h000A;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small negative offset (Backward branch)", test_num);
            PCPlus1 = 16'h0014;
            SignImm = 16'hFFF6;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PC is zero, negative offset", test_num);
            PCPlus1 = 16'h0000;
            SignImm = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum positive PC and positive offset (Wrap around)", test_num);
            PCPlus1 = 16'h7FFF;
            SignImm = 16'h0001;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum negative PC and negative offset (Wrap around)", test_num);
            PCPlus1 = 16'h8000;
            SignImm = 16'hFFFF;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large positive offset", test_num);
            PCPlus1 = 16'h1000;
            SignImm = 16'h2000;
            #1;

            check_outputs(16'h3000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large negative offset", test_num);
            PCPlus1 = 16'h4000;
            SignImm = 16'hC000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PCPlus1 at midpoint", test_num);
            PCPlus1 = 16'hABCD;
            SignImm = 16'h1234;
            #1;

            check_outputs(16'hBE01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify zero result from arbitrary inputs", test_num);
            PCPlus1 = 16'h1234;
            SignImm = 16'hEDCC;
            #1;

            check_outputs(16'h0000);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_PCBranch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCBranch === (expected_PCBranch ^ PCBranch ^ expected_PCBranch)) begin
                $display("PASS");
                $display("  Outputs: PCBranch=%h",
                         PCBranch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCBranch=%h",
                         expected_PCBranch);
                $display("  Got:      PCBranch=%h",
                         PCBranch);
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
