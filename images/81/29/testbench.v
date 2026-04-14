`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] funct;
    wire [3:0] ALUCon;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUCon(ALUCon)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOp=00 (LW/SW)", test_num);
            ALUOp = 2'b00;
            funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOp=01 (BEQ)", test_num);
            ALUOp = 2'b01;
            funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type ADD", test_num);
            ALUOp = 2'b10;
            funct = 6'b100000;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type SUB", test_num);
            ALUOp = 2'b10;
            funct = 6'b100010;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type AND", test_num);
            ALUOp = 2'b10;
            funct = 6'b100100;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type OR", test_num);
            ALUOp = 2'b10;
            funct = 6'b100101;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type SLT", test_num);
            ALUOp = 2'b10;
            funct = 6'b101010;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALUOp=00 with random funct", test_num);
            ALUOp = 2'b00;
            funct = 6'b111111;
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
        input [3:0] expected_ALUCon;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUCon === (expected_ALUCon ^ ALUCon ^ expected_ALUCon)) begin
                $display("PASS");
                $display("  Outputs: ALUCon=%h",
                         ALUCon);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUCon=%h",
                         expected_ALUCon);
                $display("  Got:      ALUCon=%h",
                         ALUCon);
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
