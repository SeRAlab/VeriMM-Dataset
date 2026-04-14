`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] LSControl;
    reg [31:0] mdr;
    wire [31:0] lsOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LSControl(LSControl),
        .mdr(mdr),
        .lsOut(lsOut)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: LSControl=01 (Full 32-bit)", test_num);
        LSControl = 2'b01;
        mdr = 32'hDEADBEEF;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: LSControl=10 (Zero-extend lower 16 bits)", test_num);
        LSControl = 2'b10;
        mdr = 32'hDEADBEEF;
        #1;

        check_outputs(32'h0000BEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: LSControl=11 (Zero-extend lower 8 bits)", test_num);
        LSControl = 2'b11;
        mdr = 32'hDEADBEEF;
        #1;

        check_outputs(32'h000000EF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: LSControl=01 (Full 32-bit All Ones)", test_num);
        LSControl = 2'b01;
        mdr = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: LSControl=10 (Zero-extend lower 16 bits All Ones)", test_num);
        LSControl = 2'b10;
        mdr = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: LSControl=11 (Zero-extend lower 8 bits All Ones)", test_num);
        LSControl = 2'b11;
        mdr = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h000000FF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: LSControl=01 (MDR with zero high bits)", test_num);
        LSControl = 2'b01;
        mdr = 32'h00001234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: LSControl=10 (MDR with zero high bits)", test_num);
        LSControl = 2'b10;
        mdr = 32'hABCD1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: LSControl=11 (MDR with zero high bits)", test_num);
        LSControl = 2'b11;
        mdr = 32'hABCD1234;
        #1;

        check_outputs(32'h00000034);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: LSControl=01 (Random pattern check)", test_num);
        LSControl = 2'b01;
        mdr = 32'hA5A5C3C3;
        #1;

        check_outputs(32'hA5A5C3C3);
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
        input [31:0] expected_lsOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lsOut === (expected_lsOut ^ lsOut ^ expected_lsOut)) begin
                $display("PASS");
                $display("  Outputs: lsOut=%h",
                         lsOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lsOut=%h",
                         expected_lsOut);
                $display("  Got:      lsOut=%h",
                         lsOut);
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
