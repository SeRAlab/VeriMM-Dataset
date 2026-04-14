`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUOp;
    reg [5:0] Funct;
    wire [4:0] ALUCtl;
    wire Sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Funct(Funct),
        .ALUCtl(ALUCtl),
        .Sign(Sign)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: R-type ADD", test_num);
        ALUOp = 4'b0010; Funct = 6'h20;
        #1;

        check_outputs(5'b00010, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: R-type SUB", test_num);
        ALUOp = 4'b0010; Funct = 6'h22;
        #1;

        check_outputs(5'b00110, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: R-type AND", test_num);
        ALUOp = 4'b0010; Funct = 6'h24;
        #1;

        check_outputs(5'b00000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: R-type OR", test_num);
        ALUOp = 4'b0010; Funct = 6'h25;
        #1;

        check_outputs(5'b00001, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: R-type SLT", test_num);
        ALUOp = 4'b0010; Funct = 6'h2a;
        #1;

        check_outputs(5'b00111, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: LW/SW Operation (ALUOp 0000)", test_num);
        ALUOp = 4'b0000; Funct = 6'hxx;
        #1;

        check_outputs(5'b00010, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Branch BEQ Operation (ALUOp 0001)", test_num);
        ALUOp = 4'b0001; Funct = 6'hxx;
        #1;

        check_outputs(5'b00110, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: I-type ORI (ALUOp 0101)", test_num);
        ALUOp = 4'b0101; Funct = 6'hxx;
        #1;

        check_outputs(5'b00001, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: R-type XOR", test_num);
        ALUOp = 4'b0010; Funct = 6'h26;
        #1;

        check_outputs(5'b00011, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: R-type NOR", test_num);
        ALUOp = 4'b0010; Funct = 6'h27;
        #1;

        check_outputs(5'b00100, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: I-type SLTI (ALUOp 1000)", test_num);
        ALUOp = 4'b1000; Funct = 6'hxx;
        #1;

        check_outputs(5'b00111, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: I-type LUI (ALUOp 0111)", test_num);
        ALUOp = 4'b0111; Funct = 6'hxx;
        #1;

        check_outputs(5'b01100, 1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input [4:0] expected_ALUCtl;
        input expected_Sign;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUCtl === (expected_ALUCtl ^ ALUCtl ^ expected_ALUCtl) &&
                expected_Sign === (expected_Sign ^ Sign ^ expected_Sign)) begin
                $display("PASS");
                $display("  Outputs: ALUCtl=%h, Sign=%b",
                         ALUCtl, Sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUCtl=%h, Sign=%b",
                         expected_ALUCtl, expected_Sign);
                $display("  Got:      ALUCtl=%h, Sign=%b",
                         ALUCtl, Sign);
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
