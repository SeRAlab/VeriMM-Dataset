`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    wire [31:0] instr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .instr(instr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reading instruction at address 0x00000000 (Immediate Format)", test_num);
            addr = 32'h00000000;

            #1;


            check_outputs(32'h00000013);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reading instruction at address 0x00000004 (Immediate Format)", test_num);
            addr = 32'h00000004;

            #1;


            check_outputs(32'h00a00093);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Reading instruction at address 0x00000008 (Load Format)", test_num);
            addr = 32'h00000008;

            #1;


            check_outputs(32'h0000a103);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reading instruction at address 0x0000000C (Store Format)", test_num);
            addr = 32'h0000000C;

            #1;


            check_outputs(32'h0020a223);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reading instruction at address 0x00000010 (R-Type Format)", test_num);
            addr = 32'h00000010;

            #1;


            check_outputs(32'h002081b3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reading instruction at an undefined address (Default/Zero)", test_num);
            addr = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Verifying combinational path - address change to 0x4", test_num);
            addr = 32'h00000004;
            #1;

            check_outputs(32'h00a00093);
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
        input [31:0] expected_instr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_instr === (expected_instr ^ instr ^ expected_instr)) begin
                $display("PASS");
                $display("  Outputs: instr=%h",
                         instr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr=%h",
                         expected_instr);
                $display("  Got:      instr=%h",
                         instr);
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
