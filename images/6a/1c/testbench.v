`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] ALUControl;
    reg ALUOut;
    reg [31:0] ALUResult;
    reg Clk;
    reg [31:0] Hi;
    reg HiWrite;
    reg [31:0] Lo;
    reg LoWrite;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUControl(ALUControl),
        .ALUOut(ALUOut),
        .ALUResult(ALUResult),
        .Clk(Clk),
        .Hi(Hi),
        .HiWrite(HiWrite),
        .Lo(Lo),
        .LoWrite(LoWrite),
        .Out(Out)
    );
    task reset_registers;

        begin
            ALUOut = 0;
            ALUControl = 6'b000000;
            ALUResult = 0;
            HiWrite = 1;
            LoWrite = 1;
            Hi = 32'h0;
            Lo = 32'h0;
            @(posedge Clk);
            #1;
            HiWrite = 0;
            LoWrite = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase001: Hi register write and read...");
        reset_registers();

        HiWrite = 1;
        Hi = 32'hA5A5_B6B6;
        @(posedge Clk);
        #1;
        HiWrite = 0;
        ALUOut = 0;
        ALUControl = 6'b010000;

        #1;


        check_outputs(32'hA5A5_B6B6);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase002: Lo register write and read...");
        reset_registers();

        LoWrite = 1;
        Lo = 32'h1234_5678;
        @(posedge Clk);
        #1;
        LoWrite = 0;
        ALUOut = 0;
        ALUControl = 6'b011111;

        #1;


        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase003: ALUOut priority check (Hi selected)...");
        reset_registers();


        HiWrite = 1;
        Hi = 32'h1111_1111;
        @(posedge Clk);
        #1;
        HiWrite = 0;


        ALUOut = 1;
        ALUResult = 32'hDEAD_BEEF;
        ALUControl = 6'b010000;

        #1;


        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase004: ALUOut priority check (Lo selected)...");
        reset_registers();


        LoWrite = 1;
        Lo = 32'h2222_2222;
        @(posedge Clk);
        #1;
        LoWrite = 0;


        ALUOut = 1;
        ALUResult = 32'hCAFE_BABE;
        ALUControl = 6'b011111;

        #1;


        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running testcase005: Simultaneous write and data persistence...");
        reset_registers();


        HiWrite = 1;
        LoWrite = 1;
        Hi = 32'h5555_AAAA;
        Lo = 32'hAAAA_5555;
        @(posedge Clk);
        #1;


        HiWrite = 0;
        LoWrite = 0;
        Hi = 32'h0;
        Lo = 32'h0;


        ALUOut = 0;
        ALUControl = 6'b010000;
        #1;
        if (Out !== 32'h5555_AAAA) fail_count = fail_count + 1;


        ALUControl = 6'b011111;
        #1;

        check_outputs(32'hAAAA_5555);
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
