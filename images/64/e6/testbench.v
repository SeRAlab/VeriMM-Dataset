`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] BusA;
    reg [31:0] Imm;
    reg [25:0] JumpAddr;
    reg [31:0] PC;
    reg Zero;
    reg [2:0] nPC_sel;
    wire [31:0] NPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BusA(BusA),
        .Imm(Imm),
        .JumpAddr(JumpAddr),
        .PC(PC),
        .Zero(Zero),
        .nPC_sel(nPC_sel),
        .NPC(NPC)
    );
    task testcase001;

    begin
        test_num = 1;
        PC = 32'h0000_1000;
        nPC_sel = 3'b000;
        Zero = 0;
        Imm = 32'h0;
        JumpAddr = 26'h0;
        BusA = 32'h0;
        $display("Test %0d: PC Increment (PC + 4)", test_num);
        #1;

        check_outputs(32'h0000_1004);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        PC = 32'h1234_5678;
        nPC_sel = 3'b000;
        $display("Test %0d: PC Increment (Large address)", test_num);
        #1;

        check_outputs(32'h1234_567C);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        PC = 32'h0000_2000;
        nPC_sel = 3'b001;
        Zero = 1;
        Imm = 32'h0000_0010;
        $display("Test %0d: Branch Taken (PC + 4 + Imm)", test_num);
        #1;

        check_outputs(32'h0000_2014);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        PC = 32'h0000_2000;
        nPC_sel = 3'b001;
        Zero = 0;
        Imm = 32'h0000_0010;
        $display("Test %0d: Branch Not Taken (PC + 4)", test_num);
        #1;

        check_outputs(32'h0000_2004);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        PC = 32'h0000_3000;
        nPC_sel = 3'b001;
        Zero = 1;
        Imm = 32'hFFFF_FFEC;
        $display("Test %0d: Branch Taken (Negative Offset)", test_num);
        #1;

        check_outputs(32'h0000_2FF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        PC = 32'h4000_0000;
        nPC_sel = 3'b010;
        JumpAddr = 26'h000_0005;
        $display("Test %0d: Jump Target Calculation", test_num);

        #1;


        check_outputs(32'h4000_0014);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        BusA = 32'hABCD_1234;
        nPC_sel = 3'b011;
        $display("Test %0d: Jump Register (NPC = BusA)", test_num);
        #1;

        check_outputs(32'hABCD_1234);
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
        input [31:0] expected_NPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NPC === (expected_NPC ^ NPC ^ expected_NPC)) begin
                $display("PASS");
                $display("  Outputs: NPC=%h",
                         NPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NPC=%h",
                         expected_NPC);
                $display("  Got:      NPC=%h",
                         NPC);
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
