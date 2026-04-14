`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [30:0] address;
    reg clk;
    reg en;
    wire [31:0] instr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .en(en),
        .instr(instr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            address = 31'h0000_0000;
            clk = 1'b0;

            #5;
            #1;

            check_outputs(32'h8000_0337);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            address = 31'h0000_0004;
            clk = 1'b0;
            #5;
            #1;

            check_outputs(32'h0003_03E7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            address = 31'h0000_0008;
            clk = 1'b0;
            #5;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            en = 1'b0;
            address = 31'h0000_0000;
            clk = 1'b0;
            #5;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            address = 31'h7FFF_FFFF;
            clk = 1'b0;
            #5;
            #1;

            check_outputs(32'h0000_0000);
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
