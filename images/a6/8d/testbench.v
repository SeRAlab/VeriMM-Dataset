`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg branch;
    reg [31:0] branch_dst;
    reg jr;
    reg [31:0] jr_dst;
    reg jump;
    reg [31:0] jump_dst;
    reg [31:0] seq_dst;
    wire [31:0] PC_dst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch(branch),
        .branch_dst(branch_dst),
        .jr(jr),
        .jr_dst(jr_dst),
        .jump(jump),
        .jump_dst(jump_dst),
        .seq_dst(seq_dst),
        .PC_dst(PC_dst)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select seq_dst (branch=0, jump=0, jr=0)", test_num);
            seq_dst = 32'hAAAA_BBBB;
            branch_dst = 32'h1111_2222;
            jump_dst = 32'h3333_4444;
            jr_dst = 32'h5555_6666;
            branch = 0;
            jump = 0;
            jr = 0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select branch_dst (branch=1)", test_num);
            seq_dst = 32'h0000_0001;
            branch_dst = 32'h0000_0002;
            jump_dst = 32'h0000_0003;
            jr_dst = 32'h0000_0004;
            branch = 1;
            jump = 0;
            jr = 0;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select jump_dst (jump=1)", test_num);
            seq_dst = 32'h1000_0000;
            branch_dst = 32'h2000_0000;
            jump_dst = 32'h3000_0000;
            jr_dst = 32'h4000_0000;
            branch = 0;
            jump = 1;
            jr = 0;
            #1;

            check_outputs(32'h3000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select jr_dst (jr=1)", test_num);
            seq_dst = 32'hDEAF_BEEF;
            branch_dst = 32'hFEED_FACE;
            jump_dst = 32'hCAFE_BABE;
            jr_dst = 32'hDEAD_BEEF;
            branch = 0;
            jump = 0;
            jr = 1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check (Multiple signals high)", test_num);


            seq_dst = 32'h0000_0010;
            branch_dst = 32'h0000_0020;
            jump_dst = 32'h0000_0030;
            jr_dst = 32'h0000_0040;


            branch = 1;
            jump = 1;
            jr = 1;

            #1;


            check_outputs(32'h0000_0040);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Resetting all controls to zero", test_num);
            seq_dst = 32'hFFFF_FFFF;
            branch_dst = 32'h0000_0000;
            jump_dst = 32'h0000_0000;
            jr_dst = 32'h0000_0000;
            branch = 0;
            jump = 0;
            jr = 0;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_PC_dst;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC_dst === (expected_PC_dst ^ PC_dst ^ expected_PC_dst)) begin
                $display("PASS");
                $display("  Outputs: PC_dst=%h",
                         PC_dst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_dst=%h",
                         expected_PC_dst);
                $display("  Got:      PC_dst=%h",
                         PC_dst);
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
