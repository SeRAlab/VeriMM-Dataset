`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUresult;
    reg MemToReg;
    reg [31:0] ReadData;
    wire [31:0] MuxOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUresult(ALUresult),
        .MemToReg(MemToReg),
        .ReadData(ReadData),
        .MuxOut(MuxOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select ALUresult (MemToReg=0)", test_num);
            ALUresult = 32'h12345678;
            ReadData  = 32'h87654321;
            MemToReg  = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select ReadData (MemToReg=1)", test_num);
            ALUresult = 32'h12345678;
            ReadData  = 32'h87654321;
            MemToReg  = 1'b1;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs All Zeros, Select ALUresult", test_num);
            ALUresult = 32'h00000000;
            ReadData  = 32'hFFFFFFFF;
            MemToReg  = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs All Ones, Select ReadData", test_num);
            ALUresult = 32'h00000000;
            ReadData  = 32'hFFFFFFFF;
            MemToReg  = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check (5/A)", test_num);
            ALUresult = 32'h55555555;
            ReadData  = 32'hAAAAAAAA;
            MemToReg  = 1'b0;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check (5/A) - Select ReadData", test_num);
            ALUresult = 32'h55555555;
            ReadData  = 32'hAAAAAAAA;
            MemToReg  = 1'b1;
            #1;

            check_outputs(32'hAAAAAAAA);
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
        input [31:0] expected_MuxOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MuxOut === (expected_MuxOut ^ MuxOut ^ expected_MuxOut)) begin
                $display("PASS");
                $display("  Outputs: MuxOut=%h",
                         MuxOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MuxOut=%h",
                         expected_MuxOut);
                $display("  Got:      MuxOut=%h",
                         MuxOut);
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
