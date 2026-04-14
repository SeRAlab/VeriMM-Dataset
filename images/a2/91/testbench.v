`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ALUResult;
    reg [1:0] RegSrc;
    reg [15:0] op2Val;
    reg [15:0] readFromMem;
    wire [15:0] outRegSrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResult(ALUResult),
        .RegSrc(RegSrc),
        .op2Val(op2Val),
        .readFromMem(readFromMem),
        .outRegSrc(outRegSrc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: RegSrc = 2'b00 (readFromMem selection)", test_num);
            readFromMem = 16'hAAAA;
            ALUResult   = 16'h1111;
            op2Val      = 16'h2222;
            RegSrc      = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: RegSrc = 2'b01 (readFromMem selection)", test_num);
            readFromMem = 16'h5555;
            ALUResult   = 16'h3333;
            op2Val      = 16'h4444;
            RegSrc      = 2'b01;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: RegSrc = 2'b10 (ALUResult selection)", test_num);
            readFromMem = 16'h0000;
            ALUResult   = 16'hBEEF;
            op2Val      = 16'hFFFF;
            RegSrc      = 2'b10;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: RegSrc = 2'b11 (op2Val selection)", test_num);
            readFromMem = 16'h1234;
            ALUResult   = 16'h5678;
            op2Val      = 16'hABCD;
            RegSrc      = 2'b11;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Verifying output changes with input when RegSrc=10", test_num);
            RegSrc      = 2'b10;
            readFromMem = 16'h0001;
            op2Val      = 16'h0002;
            ALUResult   = 16'h0003;
            #5;
            ALUResult   = 16'h9999;
            #1;

            check_outputs(16'h9999);
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
        input [15:0] expected_outRegSrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outRegSrc === (expected_outRegSrc ^ outRegSrc ^ expected_outRegSrc)) begin
                $display("PASS");
                $display("  Outputs: outRegSrc=%h",
                         outRegSrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outRegSrc=%h",
                         expected_outRegSrc);
                $display("  Got:      outRegSrc=%h",
                         outRegSrc);
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
