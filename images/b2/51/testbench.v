`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] Funct;
    wire [3:0] ALUCtrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Funct(Funct),
        .ALUCtrl(ALUCtrl)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b00;
        Funct = 6'b000000;
        #5;
        $display("Test %0d: ALUOp=00 (LW/SW), Funct=000000", test_num);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b01;
        Funct = 6'b000000;
        #5;
        $display("Test %0d: ALUOp=01 (BEQ), Funct=000000", test_num);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b10;
        Funct = 6'b100000;
        #5;
        $display("Test %0d: ALUOp=10 (R-type), Funct=ADD", test_num);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b10;
        Funct = 6'b100010;
        #5;
        $display("Test %0d: ALUOp=10 (R-type), Funct=SUB", test_num);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b10;
        Funct = 6'b100100;
        #5;
        $display("Test %0d: ALUOp=10 (R-type), Funct=AND", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b10;
        Funct = 6'b100101;
        #5;
        $display("Test %0d: ALUOp=10 (R-type), Funct=OR", test_num);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b10;
        Funct = 6'b101010;
        #5;
        $display("Test %0d: ALUOp=10 (R-type), Funct=SLT", test_num);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        ALUOp = 2'b00;
        Funct = 6'b111111;
        #5;
        $display("Test %0d: ALUOp=00 with Funct=111111", test_num);
        #1;

        check_outputs(4'b0010);
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
        input [3:0] expected_ALUCtrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUCtrl === (expected_ALUCtrl ^ ALUCtrl ^ expected_ALUCtrl)) begin
                $display("PASS");
                $display("  Outputs: ALUCtrl=%h",
                         ALUCtrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUCtrl=%h",
                         expected_ALUCtrl);
                $display("  Got:      ALUCtrl=%h",
                         ALUCtrl);
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
