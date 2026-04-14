`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC4;
    reg [31:0] PC4_imm;
    reg [1:0] PCSrc;
    reg [31:0] jump;
    wire [31:0] PCout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC4(PC4),
        .PC4_imm(PC4_imm),
        .PCSrc(PCSrc),
        .jump(jump),
        .PCout(PCout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PCSrc=0 (Select PC4)", test_num);
            PC4      = 32'h0000_1000;
            PC4_imm  = 32'h0000_2000;
            jump     = 32'h0000_3000;
            PCSrc    = 2'b00;
            #1;

            check_outputs(32'h0000_1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PCSrc=1 (Select PC4_imm)", test_num);
            PC4      = 32'hAAAA_BBBB;
            PC4_imm  = 32'hCCCC_DDDD;
            jump     = 32'hEEEE_FFFF;
            PCSrc    = 2'b01;
            #1;

            check_outputs(32'hCCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PCSrc=2 (Select jump)", test_num);
            PC4      = 32'h1234_5678;
            PC4_imm  = 32'h8765_4321;
            jump     = 32'hDEAD_BEEF;
            PCSrc    = 2'b10;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PCSrc=3 (Select jump - value 2 or higher)", test_num);
            PC4      = 32'h0000_0001;
            PC4_imm  = 32'h0000_0002;
            jump     = 32'hFFFF_FFFF;
            PCSrc    = 2'b11;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Change values and check PCSrc=0", test_num);
            PC4      = 32'h5555_5555;
            PC4_imm  = 32'h0;
            jump     = 32'h0;
            PCSrc    = 2'b00;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero, PCSrc=1", test_num);
            PC4      = 32'h0;
            PC4_imm  = 32'h0;
            jump     = 32'h0;
            PCSrc    = 2'b01;
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
        input [31:0] expected_PCout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCout === (expected_PCout ^ PCout ^ expected_PCout)) begin
                $display("PASS");
                $display("  Outputs: PCout=%h",
                         PCout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCout=%h",
                         expected_PCout);
                $display("  Got:      PCout=%h",
                         PCout);
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
