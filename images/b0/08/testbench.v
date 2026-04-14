`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BTB_FILL;
    reg BTB_PREFAIL;
    reg BranchE;
    reg [31:0] BranchTarget;
    reg JalD;
    reg [31:0] JalTarget;
    reg JalrE;
    reg [31:0] JalrTarget;
    reg [31:0] PCE;
    reg [31:0] PCF;
    reg [31:0] PCF_PRE;
    reg PCF_SEL;
    wire [31:0] PC_In;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTB_FILL(BTB_FILL),
        .BTB_PREFAIL(BTB_PREFAIL),
        .BranchE(BranchE),
        .BranchTarget(BranchTarget),
        .JalD(JalD),
        .JalTarget(JalTarget),
        .JalrE(JalrE),
        .JalrTarget(JalrTarget),
        .PCE(PCE),
        .PCF(PCF),
        .PCF_PRE(PCF_PRE),
        .PCF_SEL(PCF_SEL),
        .PC_In(PC_In)
    );
    task init_signals;

        begin
            BTB_FILL = 0;
            BTB_PREFAIL = 0;
            BranchE = 0;
            BranchTarget = 32'h0;
            JalD = 0;
            JalTarget = 32'h0;
            JalrE = 0;
            JalrTarget = 32'h0;
            PCE = 32'h0;
            PCF = 32'h0;
            PCF_PRE = 32'h0;
            PCF_SEL = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            init_signals();
            PCF = 32'h0000_1000;
            $display("Test %0d: Default Sequential Fetch (PCF + 4)", test_num);
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            init_signals();
            PCF = 32'h0000_1000;
            PCF_PRE = 32'h0000_2000;
            PCF_SEL = 1;
            $display("Test %0d: Selection of Pre-computed PC (PCF_PRE)", test_num);
            #1;

            check_outputs(32'h0000_2000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            init_signals();
            JalD = 1;
            JalTarget = 32'h0000_3000;
            PCF = 32'h0000_1000;
            $display("Test %0d: JAL Target Selection", test_num);
            #1;

            check_outputs(32'h0000_3000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            init_signals();
            BranchE = 1;
            BTB_FILL = 1;
            BranchTarget = 32'h0000_4000;
            JalD = 1;
            $display("Test %0d: Branch Taken and BTB Filled", test_num);
            #1;

            check_outputs(32'h0000_4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            init_signals();
            JalrE = 1;
            JalrTarget = 32'h0000_5000;
            BranchE = 1;
            BTB_FILL = 1;
            $display("Test %0d: JALR Selection", test_num);
            #1;

            check_outputs(32'h0000_5000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            init_signals();
            BTB_PREFAIL = 1;
            BranchE = 1;
            BranchTarget = 32'h0000_6000;
            $display("Test %0d: Prediction Failure - Recovering to Branch Target", test_num);
            #1;

            check_outputs(32'h0000_6000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            init_signals();
            BTB_PREFAIL = 1;
            BranchE = 0;
            PCE = 32'h0000_7000;
            $display("Test %0d: Prediction Failure - Recovering to Sequential (PCE + 4)", test_num);
            #1;

            check_outputs(32'h0000_7004);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            init_signals();
            BTB_PREFAIL = 1;
            BranchE = 1;
            BranchTarget = 32'hAAAA_BBBB;
            JalrE = 1;
            JalrTarget = 32'hCCCC_DDDD;
            $display("Test %0d: Priority Check - BTB_PREFAIL Highest", test_num);
            #1;

            check_outputs(32'hAAAA_BBBB);
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
        input [31:0] expected_PC_In;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC_In === (expected_PC_In ^ PC_In ^ expected_PC_In)) begin
                $display("PASS");
                $display("  Outputs: PC_In=%h",
                         PC_In);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_In=%h",
                         expected_PC_In);
                $display("  Got:      PC_In=%h",
                         PC_In);
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
