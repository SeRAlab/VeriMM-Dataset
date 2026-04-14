`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dirJump;
    reg [31:0] dirReg;
    reg [31:0] opCode;
    wire [31:0] dir;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dirJump(dirJump),
        .dirReg(dirReg),
        .opCode(opCode),
        .dir(dir)
    );
    task testcase001;

    begin
        test_num = 1;
        opCode = 32'h00000008;
        dirReg = 32'hAAAA_BBBB;
        dirJump = 32'h1111_2222;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        opCode = 32'h00000002;
        dirReg = 32'hAAAA_BBBB;
        dirJump = 32'h1111_2222;
        #1;

        check_outputs(32'h1111_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        opCode = 32'h00000000;
        dirReg = 32'h5555_6666;
        dirJump = 32'h7777_8888;
        #1;

        check_outputs(32'h7777_8888);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        opCode = 32'h00000008;
        dirReg = 32'h0000_0000;
        dirJump = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        opCode = 32'h00000004;
        dirReg = 32'hCAFE_BABE;
        dirJump = 32'hDEAD_BEEF;
        #1;

        check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_dir;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dir === (expected_dir ^ dir ^ expected_dir)) begin
                $display("PASS");
                $display("  Outputs: dir=%h",
                         dir);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir=%h",
                         expected_dir);
                $display("  Got:      dir=%h",
                         dir);
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
