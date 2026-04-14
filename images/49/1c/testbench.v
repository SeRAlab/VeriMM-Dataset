`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg AluSrc;
    reg ComBranch;
    reg [31:0] R2;
    reg [31:0] extend;
    reg shift;
    reg [31:0] shift_num;
    reg syscall;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluSrc(AluSrc),
        .ComBranch(ComBranch),
        .R2(R2),
        .extend(extend),
        .shift(shift),
        .shift_num(shift_num),
        .syscall(syscall),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select R2 (AluSrc=0, shift=0, ComBranch=0, syscall=0)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 0;
        shift = 0;
        ComBranch = 0;
        syscall = 0;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select extend (AluSrc=1, shift=0, ComBranch=0, syscall=0)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 1;
        shift = 0;
        ComBranch = 0;
        syscall = 0;
        #1;

        check_outputs(32'h1111_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select shift_num (AluSrc=0, shift=1, ComBranch=0, syscall=0)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 0;
        shift = 1;
        ComBranch = 0;
        syscall = 0;
        #1;

        check_outputs(32'h5555_6666);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: shift overrides AluSrc (AluSrc=1, shift=1, ComBranch=0, syscall=0)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 1;
        shift = 1;
        ComBranch = 0;
        syscall = 0;
        #1;

        check_outputs(32'h5555_6666);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ComBranch active (ComBranch=1, others vary)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 1;
        shift = 1;
        ComBranch = 1;
        syscall = 0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Syscall active (syscall=1)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 0;
        shift = 0;
        ComBranch = 0;
        syscall = 1;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Syscall overrides ComBranch (syscall=1, ComBranch=1)", test_num);
        R2 = 32'hAAAA_BBBB;
        extend = 32'h1111_2222;
        shift_num = 32'h5555_6666;
        AluSrc = 1;
        shift = 1;
        ComBranch = 1;
        syscall = 1;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero data inputs, R2 selected", test_num);
        R2 = 32'h0;
        extend = 32'h0;
        shift_num = 32'h0;
        AluSrc = 0;
        shift = 0;
        ComBranch = 0;
        syscall = 0;
        #1;

        check_outputs(32'h0);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
