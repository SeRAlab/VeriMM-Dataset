`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BranchE;
    reg [31:0] BranchTarget;
    reg JalD;
    reg [31:0] JalTarget;
    reg JalrE;
    reg [31:0] JalrTarget;
    reg [31:0] PCF;
    wire [31:0] PC_In;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BranchE(BranchE),
        .BranchTarget(BranchTarget),
        .JalD(JalD),
        .JalTarget(JalTarget),
        .JalrE(JalrE),
        .JalrTarget(JalrTarget),
        .PCF(PCF),
        .PC_In(PC_In)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Sequential Increment (PC + 4)", test_num);
        PCF = 32'h0000_1000;
        JalrTarget = 32'h0000_2000;
        BranchTarget = 32'h0000_3000;
        JalTarget = 32'h0000_4000;
        BranchE = 0;
        JalD = 0;
        JalrE = 0;
        #10;
        #1;

        check_outputs(32'h0000_1004);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: JAL Target Selection (JalD=1)", test_num);
        PCF = 32'h0000_1000;
        JalTarget = 32'h0000_5555;
        BranchE = 0;
        JalD = 1;
        JalrE = 0;
        #10;
        #1;

        check_outputs(32'h0000_5555);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Branch Target Selection (BranchE=1)", test_num);
        PCF = 32'h0000_1000;
        BranchTarget = 32'h0000_AAAA;
        BranchE = 1;
        JalD = 0;
        JalrE = 0;
        #10;
        #1;

        check_outputs(32'h0000_AAAA);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: JALR Target Selection (JalrE=1)", test_num);
        PCF = 32'h0000_1000;
        JalrTarget = 32'h0000_CCCC;
        BranchE = 0;
        JalD = 0;
        JalrE = 1;
        #10;
        #1;

        check_outputs(32'h0000_CCCC);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Priority Check - JalrE vs BranchE", test_num);


        PCF = 32'h0000_1000;
        JalrTarget = 32'h0000_1111;
        BranchTarget = 32'h0000_2222;
        JalrE = 1;
        BranchE = 1;
        JalD = 0;
        #10;
        #1;

        check_outputs(32'h0000_1111);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Priority Check - BranchE vs JalD", test_num);

        PCF = 32'h0000_1000;
        BranchTarget = 32'h0000_BBBB;
        JalTarget = 32'h0000_DDDD;
        BranchE = 1;
        JalD = 1;
        JalrE = 0;
        #10;
        #1;

        check_outputs(32'h0000_BBBB);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Boundary Address (Maximum 32-bit)", test_num);
        PCF = 32'hFFFF_FFFC;
        BranchE = 0;
        JalD = 0;
        JalrE = 0;
        #10;
        #1;

        check_outputs(32'h0000_0000);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: All signals active (Priority test)", test_num);
        PCF = 32'h0000_1000;
        JalrTarget   = 32'h1111_1111;
        BranchTarget = 32'h2222_2222;
        JalTarget    = 32'h3333_3333;
        JalrE = 1;
        BranchE = 1;
        JalD = 1;
        #10;

        #1;


        check_outputs(32'h1111_1111);
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
