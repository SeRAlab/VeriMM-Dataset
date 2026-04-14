`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cout;
    reg Zero;
    reg clk;
    reg [5:0] cntlInstruc;
    reg rst;
    wire AluOrMem;
    wire MWE;
    wire RFWE;
    wire RdOrR2;
    wire [1:0] pcContrl;
    wire [1:0] stackContrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cout(Cout),
        .Zero(Zero),
        .clk(clk),
        .cntlInstruc(cntlInstruc),
        .rst(rst),
        .AluOrMem(AluOrMem),
        .MWE(MWE),
        .RFWE(RFWE),
        .RdOrR2(RdOrR2),
        .pcContrl(pcContrl),
        .stackContrl(stackContrl)
    );
    task testcase001;

    begin
        test_num = 1;
        rst = 1;
        cntlInstruc = 6'b000000;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #2 rst = 0;
        #1;

        check_outputs(0, 0, 0, 0, 2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b000001;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 1, 0, 2'b00, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b001000;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(1, 0, 1, 0, 2'b00, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b001001;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 1, 0, 0, 2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b000100;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 1, 2'b00, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b010000;
        Zero = 1;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0, 2'b01, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b010000;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0, 2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b100000;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0, 2'b01, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b100001;
        Zero = 0;
        Cout = 0;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0, 2'b10, 2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        rst = 1; @(posedge clk); #2 rst = 0;
        cntlInstruc = 6'b010001;
        Zero = 0;
        Cout = 1;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0, 2'b01, 2'b00);
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
        input expected_AluOrMem;
        input expected_MWE;
        input expected_RFWE;
        input expected_RdOrR2;
        input [1:0] expected_pcContrl;
        input [1:0] expected_stackContrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AluOrMem === (expected_AluOrMem ^ AluOrMem ^ expected_AluOrMem) &&
                expected_MWE === (expected_MWE ^ MWE ^ expected_MWE) &&
                expected_RFWE === (expected_RFWE ^ RFWE ^ expected_RFWE) &&
                expected_RdOrR2 === (expected_RdOrR2 ^ RdOrR2 ^ expected_RdOrR2) &&
                expected_pcContrl === (expected_pcContrl ^ pcContrl ^ expected_pcContrl) &&
                expected_stackContrl === (expected_stackContrl ^ stackContrl ^ expected_stackContrl)) begin
                $display("PASS");
                $display("  Outputs: AluOrMem=%b, MWE=%b, RFWE=%b, RdOrR2=%b, pcContrl=%h, stackContrl=%h",
                         AluOrMem, MWE, RFWE, RdOrR2, pcContrl, stackContrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AluOrMem=%b, MWE=%b, RFWE=%b, RdOrR2=%b, pcContrl=%h, stackContrl=%h",
                         expected_AluOrMem, expected_MWE, expected_RFWE, expected_RdOrR2, expected_pcContrl, expected_stackContrl);
                $display("  Got:      AluOrMem=%b, MWE=%b, RFWE=%b, RdOrR2=%b, pcContrl=%h, stackContrl=%h",
                         AluOrMem, MWE, RFWE, RdOrR2, pcContrl, stackContrl);
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
