`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUop;
    reg [5:0] FuncCode;
    wire [3:0] ALUCtrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .FuncCode(FuncCode),
        .ALUCtrl(ALUCtrl)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: ALUop = 0000 (Transparent mode)", test_num);
            ALUop = 4'b0000;
            FuncCode = 6'b000000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: ALUop = 0101 (Transparent mode)", test_num);
            ALUop = 4'b0101;
            FuncCode = 6'b111111;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: ALUop = 1010 (Transparent mode)", test_num);
            ALUop = 4'b1010;
            FuncCode = 6'b010101;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: ALUop = 1110 (Boundary transparent mode)", test_num);
            ALUop = 4'b1110;
            FuncCode = 6'b100000;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: ALUop = 1111, FuncCode = 32 (ADD)", test_num);
            ALUop = 4'b1111;
            FuncCode = 6'd32;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: ALUop = 1111, FuncCode = 34 (SUB)", test_num);
            ALUop = 4'b1111;
            FuncCode = 6'd34;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: ALUop = 1111, FuncCode = 36 (AND)", test_num);
            ALUop = 4'b1111;
            FuncCode = 6'd36;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: ALUop = 1111, FuncCode = 37 (OR)", test_num);
            ALUop = 4'b1111;
            FuncCode = 6'd37;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: ALUop = 1111, FuncCode = 42 (SLT)", test_num);
            ALUop = 4'b1111;
            FuncCode = 6'd42;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: ALUop = 1111, FuncCode = 39 (NOR)", test_num);
            ALUop = 4'b1111;
            FuncCode = 6'd39;
            #1;

            check_outputs(4'b1100);
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
