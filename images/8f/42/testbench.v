`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] OPCODE;
    wire [8:0] DECODED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OPCODE(OPCODE),
        .DECODED(DECODED)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Opcode 0x01", test_num);
            OPCODE = 8'h01;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Opcode 0x02", test_num);
            OPCODE = 8'h02;
            #1;

            check_outputs(9'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Opcode 0x03", test_num);
            OPCODE = 8'h03;
            #1;

            check_outputs(9'h004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Undefined Opcode 0xFF", test_num);
            OPCODE = 8'hFF;
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Undefined Opcode 0x00", test_num);
            OPCODE = 8'h00;
            #1;

            check_outputs(9'h100);
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
        input [8:0] expected_DECODED;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DECODED === (expected_DECODED ^ DECODED ^ expected_DECODED)) begin
                $display("PASS");
                $display("  Outputs: DECODED=%h",
                         DECODED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DECODED=%h",
                         expected_DECODED);
                $display("  Got:      DECODED=%h",
                         DECODED);
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
