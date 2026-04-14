`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] op1;
    reg [1:0] operation;
    reg [4:0] shamt;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1(op1),
        .operation(operation),
        .shamt(shamt),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLL simple shift", test_num);
            op1 = 32'h00000001;
            shamt = 5'd4;
            operation = 2'b01;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLL shift out MSB", test_num);
            op1 = 32'h80000001;
            shamt = 5'd1;
            operation = 2'b01;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SRL basic shift", test_num);
            op1 = 32'h80000000;
            shamt = 5'd1;
            operation = 2'b10;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SRL large shift", test_num);
            op1 = 32'hFFFFFFFF;
            shamt = 5'd31;
            operation = 2'b10;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SRA negative number sign preservation", test_num);
            op1 = 32'h80000000;
            shamt = 5'd4;
            operation = 2'b11;
            #1;

            check_outputs(32'hF8000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SRA positive number sign preservation", test_num);
            op1 = 32'h7FFFFFFF;
            shamt = 5'd4;
            operation = 2'b11;
            #1;

            check_outputs(32'h07FFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SRA shift by 31 (Negative)", test_num);
            op1 = 32'hF0000000;
            shamt = 5'd31;
            operation = 2'b11;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLL shift by zero", test_num);
            op1 = 32'hDEADBEEF;
            shamt = 5'd0;
            operation = 2'b01;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SRL shift by zero", test_num);
            op1 = 32'hA5A5A5A5;
            shamt = 5'd0;
            operation = 2'b10;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLL maximum shift", test_num);
            op1 = 32'h00000001;
            shamt = 5'd31;
            operation = 2'b01;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
