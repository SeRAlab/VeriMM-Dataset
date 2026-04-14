`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUresult;
    reg [1:0] MemtoReg;
    reg [31:0] PCplus;
    reg [31:0] rdata;
    wire [31:0] writedata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUresult(ALUresult),
        .MemtoReg(MemtoReg),
        .PCplus(PCplus),
        .rdata(rdata),
        .writedata(writedata)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select ALUresult (MemtoReg = 00)", test_num);
            ALUresult = 32'hDEADBEEF;
            rdata     = 32'hCAFEBABE;
            PCplus    = 32'h12345678;
            MemtoReg  = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select rdata (MemtoReg = 01)", test_num);
            ALUresult = 32'hDEADBEEF;
            rdata     = 32'hCAFEBABE;
            PCplus    = 32'h12345678;
            MemtoReg  = 2'b01;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select PCplus (MemtoReg = 10)", test_num);
            ALUresult = 32'hDEADBEEF;
            rdata     = 32'hCAFEBABE;
            PCplus    = 32'h12345678;
            MemtoReg  = 2'b10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All zeros check", test_num);
            ALUresult = 32'h00000000;
            rdata     = 32'h00000000;
            PCplus    = 32'h00000000;
            MemtoReg  = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All ones check", test_num);
            ALUresult = 32'hFFFFFFFF;
            rdata     = 32'hFFFFFFFF;
            PCplus    = 32'hFFFFFFFF;
            MemtoReg  = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating bits selection (ALUresult)", test_num);
            ALUresult = 32'hAAAAAAAA;
            rdata     = 32'h55555555;
            PCplus    = 32'h0000FFFF;
            MemtoReg  = 2'b00;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Alternating bits selection (rdata)", test_num);
            ALUresult = 32'hAAAAAAAA;
            rdata     = 32'h55555555;
            PCplus    = 32'h0000FFFF;
            MemtoReg  = 2'b01;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Alternating bits selection (PCplus)", test_num);
            ALUresult = 32'hAAAAAAAA;
            rdata     = 32'h55555555;
            PCplus    = 32'h0000FFFF;
            MemtoReg  = 2'b10;
            #1;

            check_outputs(32'h0000FFFF);
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
        input [31:0] expected_writedata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_writedata === (expected_writedata ^ writedata ^ expected_writedata)) begin
                $display("PASS");
                $display("  Outputs: writedata=%h",
                         writedata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: writedata=%h",
                         expected_writedata);
                $display("  Got:      writedata=%h",
                         writedata);
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
