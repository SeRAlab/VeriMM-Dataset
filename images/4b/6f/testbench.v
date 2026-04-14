`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EXTOp;
    reg LUOp;
    reg [31:0] PCplus;
    reg [15:0] imm;
    wire [31:0] ConBA;
    wire [31:0] immout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXTOp(EXTOp),
        .LUOp(LUOp),
        .PCplus(PCplus),
        .imm(imm),
        .ConBA(ConBA),
        .immout(immout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Extension, Positive Imm", test_num);
            EXTOp = 1'b0;
            LUOp = 1'b0;
            PCplus = 32'h00001000;
            imm = 16'h1234;



            #1;




            check_outputs(32'h000058D0, 32'h00001234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Extension, Negative Imm", test_num);
            EXTOp = 1'b0;
            LUOp = 1'b0;
            PCplus = 32'h00002000;
            imm = 16'h8001;



            #1;




            check_outputs(32'h00022004, 32'h00008001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sign Extension, Positive Imm", test_num);
            EXTOp = 1'b1;
            LUOp = 1'b0;
            PCplus = 32'h00003000;
            imm = 16'h1234;



            #1;




            check_outputs(32'h000078D0, 32'h00001234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sign Extension, Negative Imm", test_num);
            EXTOp = 1'b1;
            LUOp = 1'b0;
            PCplus = 32'h00004000;
            imm = 16'h8001;



            #1;




            check_outputs(32'hFFFE4004, 32'hFFFF8001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LUOp High with Sign Extension", test_num);
            EXTOp = 1'b1;
            LUOp = 1'b1;
            PCplus = 32'h00001000;
            imm = 16'hFFFF;



            #1;




            check_outputs(32'h00000FFC, 32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex PC and Sign Extension", test_num);
            EXTOp = 1'b1;
            LUOp = 1'b0;
            PCplus = 32'hFFFFFFFC;
            imm = 16'h0001;


            #1;



            check_outputs(32'h00000000, 32'h00000001);
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
        input [31:0] expected_ConBA;
        input [31:0] expected_immout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ConBA === (expected_ConBA ^ ConBA ^ expected_ConBA) &&
                expected_immout === (expected_immout ^ immout ^ expected_immout)) begin
                $display("PASS");
                $display("  Outputs: ConBA=%h, immout=%h",
                         ConBA, immout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ConBA=%h, immout=%h",
                         expected_ConBA, expected_immout);
                $display("  Got:      ConBA=%h, immout=%h",
                         ConBA, immout);
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
