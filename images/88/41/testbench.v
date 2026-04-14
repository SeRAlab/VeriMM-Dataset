`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Jump;
    reg [3:0] PCPlus4;
    reg [31:0] PC_BMUX;
    reg [27:0] ins;
    wire [31:0] PC_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Jump(Jump),
        .PCPlus4(PCPlus4),
        .PC_BMUX(PC_BMUX),
        .ins(ins),
        .PC_out(PC_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump = 0, Select PC_BMUX", test_num);
            Jump = 1'b0;
            PC_BMUX = 32'hDEADBEEF;
            PCPlus4 = 4'hF;
            ins = 28'h0AAAAAA;
            #10;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump = 1, Select Concatenated PC", test_num);
            Jump = 1'b1;
            PC_BMUX = 32'hDEADBEEF;
            PCPlus4 = 4'hA;
            ins = 28'h1234567;
            #10;

            #1;


            check_outputs(32'hA1234567);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump = 1, All Zeros in Concat", test_num);
            Jump = 1'b1;
            PC_BMUX = 32'hFFFFFFFF;
            PCPlus4 = 4'h0;
            ins = 28'h0000000;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump = 1, All Ones in Concat", test_num);
            Jump = 1'b1;
            PC_BMUX = 32'h00000000;
            PCPlus4 = 4'hF;
            ins = 28'hFFFFFFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Jump with Fixed Inputs", test_num);
            PC_BMUX = 32'h12345678;
            PCPlus4 = 4'h5;
            ins = 28'hABCDEF0;


            Jump = 1'b0;
            #5;


            Jump = 1'b1;
            #5;
            #1;

            check_outputs(32'h5ABCDEF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Bits Check", test_num);
            Jump = 1'b1;
            PCPlus4 = 4'b1001;
            ins = 28'h8000001;
            PC_BMUX = 32'h0;
            #10;

            #1;


            check_outputs(32'h98000001);
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
        input [31:0] expected_PC_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC_out === (expected_PC_out ^ PC_out ^ expected_PC_out)) begin
                $display("PASS");
                $display("  Outputs: PC_out=%h",
                         PC_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_out=%h",
                         expected_PC_out);
                $display("  Got:      PC_out=%h",
                         PC_out);
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
