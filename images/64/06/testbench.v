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
        $display("Test Case %0d: Reading address 0x00000000", test_num);
        addr = 32'h00000000;



        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Reading address 0x00000004", test_num);
        addr = 32'h00000004;
        #10;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Reading address 0x00000008", test_num);
        addr = 32'h00000008;
        #10;
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Reading address 0x0000000C", test_num);
        addr = 32'h0000000C;
        #10;
        #1;

        check_outputs(32'h0000000C);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Reading address 0x00000010", test_num);
        addr = 32'h00000010;
        #10;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Reading address 0x00000100", test_num);
        addr = 32'h00000100;
        #10;
        #1;

        check_outputs(32'h00000100);
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
