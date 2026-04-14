`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] instr;
    wire [31:0] SignImm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .SignImm(SignImm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero", test_num);
            instr = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Positive Value", test_num);
            instr = 16'h0001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive 16-bit Value (MSB 0)", test_num);
            instr = 16'h7FFF;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Negative 16-bit Value (MSB 1)", test_num);
            instr = 16'h8000;
            #1;

            check_outputs(32'xFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative One", test_num);
            instr = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Positive Value", test_num);
            instr = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Negative Value", test_num);
            instr = 16'hABCD;
            #1;

            check_outputs(32'hFFFFABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 1010...", test_num);
            instr = 16'hAAAA;
            #1;

            check_outputs(32'hFFFFAAAA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0101...", test_num);
            instr = 16'h5555;
            #1;

            check_outputs(32'h00005555);
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
        input [31:0] expected_SignImm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SignImm === (expected_SignImm ^ SignImm ^ expected_SignImm)) begin
                $display("PASS");
                $display("  Outputs: SignImm=%h",
                         SignImm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SignImm=%h",
                         expected_SignImm);
                $display("  Got:      SignImm=%h",
                         SignImm);
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
