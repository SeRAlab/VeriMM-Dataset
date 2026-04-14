`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Zero;
    reg clk;
    reg [5:0] fun;
    reg [5:0] op;
    wire ALUOp;
    wire BSel;
    wire DMWr;
    wire [1:0] ExtOp;
    wire [1:0] GPRSel;
    wire GPRWr;
    wire IRWr;
    wire [1:0] NPCOp;
    wire PCWr;
    wire [1:0] WDSel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Zero(Zero),
        .clk(clk),
        .fun(fun),
        .op(op),
        .ALUOp(ALUOp),
        .BSel(BSel),
        .DMWr(DMWr),
        .ExtOp(ExtOp),
        .GPRSel(GPRSel),
        .GPRWr(GPRWr),
        .IRWr(IRWr),
        .NPCOp(NPCOp),
        .PCWr(PCWr),
        .WDSel(WDSel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Fetch Cycle (S0)", test_num);
        op = 6'b0; fun = 6'b0; Zero = 0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0, 1'b1, 2'b01, 1'b1, 2'b00);
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: R-Type ADD (Write Back S7)", test_num);

        op = 6'b000000; fun = 6'b100000; Zero = 0;


        @(posedge clk);
        @(posedge clk);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 2'b01, 1'b1, 1'b0, 2'b00, 1'b0, 2'b00);
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: LW (Write Back S4)", test_num);

        op = 6'b100011; fun = 6'b0; Zero = 0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b1, 1'b0, 2'b00, 1'b0, 2'b01);
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: SW (Mem Write S5)", test_num);

        op = 6'b101011; fun = 6'b0; Zero = 0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 2'b00, 2'b00, 1'b0, 1'b0, 2'b00, 1'b0, 2'b00);
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: BEQ Taken (Branch S8)", test_num);

        op = 6'b000100; fun = 6'b0; Zero = 1;

        @(posedge clk);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0, 1'b0, 2'b10, 1'b1, 2'b00);
        @(posedge clk);
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
        input expected_ALUOp;
        input expected_BSel;
        input expected_DMWr;
        input [1:0] expected_ExtOp;
        input [1:0] expected_GPRSel;
        input expected_GPRWr;
        input expected_IRWr;
        input [1:0] expected_NPCOp;
        input expected_PCWr;
        input [1:0] expected_WDSel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_BSel === (expected_BSel ^ BSel ^ expected_BSel) &&
                expected_DMWr === (expected_DMWr ^ DMWr ^ expected_DMWr) &&
                expected_ExtOp === (expected_ExtOp ^ ExtOp ^ expected_ExtOp) &&
                expected_GPRSel === (expected_GPRSel ^ GPRSel ^ expected_GPRSel) &&
                expected_GPRWr === (expected_GPRWr ^ GPRWr ^ expected_GPRWr) &&
                expected_IRWr === (expected_IRWr ^ IRWr ^ expected_IRWr) &&
                expected_NPCOp === (expected_NPCOp ^ NPCOp ^ expected_NPCOp) &&
                expected_PCWr === (expected_PCWr ^ PCWr ^ expected_PCWr) &&
                expected_WDSel === (expected_WDSel ^ WDSel ^ expected_WDSel)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%b, BSel=%b, DMWr=%b, ExtOp=%h, GPRSel=%h, GPRWr=%b, IRWr=%b, NPCOp=%h, PCWr=%b, WDSel=%h",
                         ALUOp, BSel, DMWr, ExtOp, GPRSel, GPRWr, IRWr, NPCOp, PCWr, WDSel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%b, BSel=%b, DMWr=%b, ExtOp=%h, GPRSel=%h, GPRWr=%b, IRWr=%b, NPCOp=%h, PCWr=%b, WDSel=%h",
                         expected_ALUOp, expected_BSel, expected_DMWr, expected_ExtOp, expected_GPRSel, expected_GPRWr, expected_IRWr, expected_NPCOp, expected_PCWr, expected_WDSel);
                $display("  Got:      ALUOp=%b, BSel=%b, DMWr=%b, ExtOp=%h, GPRSel=%h, GPRWr=%b, IRWr=%b, NPCOp=%h, PCWr=%b, WDSel=%h",
                         ALUOp, BSel, DMWr, ExtOp, GPRSel, GPRWr, IRWr, NPCOp, PCWr, WDSel);
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
