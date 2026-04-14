`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr_i;
    wire [31:0] instr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .instr_o(instr_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing word at address 0x0 (Aligned)", test_num);
        addr_i = 32'h00000000;
        #1;

        check_outputs(32'h00000033);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing word at address 0x4 (Aligned)", test_num);
        addr_i = 32'h00000004;
        #1;

        check_outputs(32'h00108093);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing word at address 0x8 (Aligned)", test_num);
        addr_i = 32'h00000008;
        #1;

        check_outputs(32'h00208113);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Accessing word at address 0xC (Aligned)", test_num);
        addr_i = 32'h0000000C;
        #1;

        check_outputs(32'h00308193);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking address 0x1 (Should map to Word 0 index)", test_num);
        addr_i = 32'h00000001;
        #1;

        check_outputs(32'h00000033);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking address 0x3 (Should map to Word 0 index)", test_num);
        addr_i = 32'h00000003;
        #1;

        check_outputs(32'h00000033);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking address 0x5 (Should map to Word 1 index)", test_num);
        addr_i = 32'h00000005;
        #1;

        check_outputs(32'h00108093);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking address 0xA (Should map to Word 2 index)", test_num);
        addr_i = 32'h0000000A;
        #1;

        check_outputs(32'h00208113);
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
        input [31:0] expected_instr_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_instr_o === (expected_instr_o ^ instr_o ^ expected_instr_o)) begin
                $display("PASS");
                $display("  Outputs: instr_o=%h",
                         instr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_o=%h",
                         expected_instr_o);
                $display("  Got:      instr_o=%h",
                         instr_o);
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
