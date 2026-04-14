`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] instr;
    wire [15:0] forced_instr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .forced_instr(forced_instr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            instr = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            instr = 16'hFFFF;
            #1;

            check_outputs(16'h0FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Top 4 bits only", test_num);
            instr = 16'hF000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Bottom 12 bits only", test_num);
            instr = 16'h0FFF;
            #1;

            check_outputs(16'h0FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Pattern AAAA", test_num);
            instr = 16'hAAAA;
            #1;

            check_outputs(16'h0AAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Pattern 5555", test_num);
            instr = 16'h5555;
            #1;

            check_outputs(16'h0555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Random HEX ABCD", test_num);
            instr = 16'hABCD;
            #1;

            check_outputs(16'h0BCD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Instruction with MSB set", test_num);
            instr = 16'h8123;
            #1;

            check_outputs(16'h0123);
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
        input [15:0] expected_forced_instr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forced_instr === (expected_forced_instr ^ forced_instr ^ expected_forced_instr)) begin
                $display("PASS");
                $display("  Outputs: forced_instr=%h",
                         forced_instr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forced_instr=%h",
                         expected_forced_instr);
                $display("  Got:      forced_instr=%h",
                         forced_instr);
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
