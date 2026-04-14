`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUOutM;
    reg [1:0] ForwardAE;
    reg [31:0] RD1_out;
    reg [31:0] ResultW;
    wire [31:0] SrcAE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOutM(ALUOutM),
        .ForwardAE(ForwardAE),
        .RD1_out(RD1_out),
        .ResultW(ResultW),
        .SrcAE(SrcAE)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select RD1_out (ForwardAE = 00)", test_num);
            RD1_out   = 32'hA5A5A5A5;
            ResultW   = 32'h5A5A5A5A;
            ALUOutM   = 32'hFFFFFFFF;
            ForwardAE = 2'b00;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select ResultW (ForwardAE = 01)", test_num);
            RD1_out   = 32'h11111111;
            ResultW   = 32'h22222222;
            ALUOutM   = 32'h33333333;
            ForwardAE = 2'b01;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select ALUOutM (ForwardAE = 10)", test_num);
            RD1_out   = 32'hDEADC0DE;
            ResultW   = 32'hFEEDFACE;
            ALUOutM   = 32'hBEEFCAFE;
            ForwardAE = 2'b10;
            #1;

            check_outputs(32'hBEEFCAFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All inputs zero, Select RD1_out", test_num);
            RD1_out   = 32'h00000000;
            ResultW   = 32'h00000000;
            ALUOutM   = 32'h00000000;
            ForwardAE = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Edge case - All Fs, Select ResultW", test_num);
            RD1_out   = 32'h0;
            ResultW   = 32'hFFFFFFFF;
            ALUOutM   = 32'h0;
            ForwardAE = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Random pattern, Select ALUOutM", test_num);
            RD1_out   = 32'h12345678;
            ResultW   = 32'h9ABCDEF0;
            ALUOutM   = 32'hCAFE1234;
            ForwardAE = 2'b10;
            #1;

            check_outputs(32'hCAFE1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Switching ForwardAE from 10 to 00", test_num);
            RD1_out   = 32'hAAAA5555;
            ResultW   = 32'hCCCC3333;
            ALUOutM   = 32'h0000FFFF;
            ForwardAE = 2'b10;
            #5;
            ForwardAE = 2'b00;
            #1;

            check_outputs(32'hAAAA5555);
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
        input [31:0] expected_SrcAE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SrcAE === (expected_SrcAE ^ SrcAE ^ expected_SrcAE)) begin
                $display("PASS");
                $display("  Outputs: SrcAE=%h",
                         SrcAE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SrcAE=%h",
                         expected_SrcAE);
                $display("  Got:      SrcAE=%h",
                         SrcAE);
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
