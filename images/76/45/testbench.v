`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ID_stall;
    reg [31:0] IF_PC;
    reg [31:0] IF_PCnext;
    reg IF_flush;
    reg [31:0] IF_inst;
    reg IF_stall;
    reg clk;
    reg rst;
    wire [31:0] ID_PCnext;
    wire [31:0] ID_inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ID_stall(ID_stall),
        .IF_PC(IF_PC),
        .IF_PCnext(IF_PCnext),
        .IF_flush(IF_flush),
        .IF_inst(IF_inst),
        .IF_stall(IF_stall),
        .clk(clk),
        .rst(rst),
        .ID_PCnext(ID_PCnext),
        .ID_inst(ID_inst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ID_stall = 0;
        IF_PC = 0;
        IF_PCnext = 0;
        IF_flush = 0;
        IF_inst = 0;
        IF_stall = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Normal Pass-through", test_num);
        reset_dut();

        IF_inst = 32'hA1B2C3D4;
        IF_PCnext = 32'h00001004;
        IF_PC = 32'h00001000;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00001004, 32'hA1B2C3D4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ID Stall (Hold Value)", test_num);
        reset_dut();


        IF_inst = 32'h11111111;
        IF_PCnext = 32'h00000004;
        @(posedge clk);
        #1;


        ID_stall = 1;
        IF_inst = 32'hFFFFFFFF;
        IF_PCnext = 32'h00000008;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00000004, 32'h11111111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: IF Flush (Clear Data)", test_num);
        reset_dut();


        IF_inst = 32'hAAAAAAAA;
        IF_PCnext = 32'h0000000C;
        @(posedge clk);
        #1;

        IF_flush = 1;
        IF_inst = 32'hBBBBBBBB;
        IF_PCnext = 32'h00000010;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Flush Priority over Stall", test_num);
        reset_dut();


        IF_inst = 32'h12345678;
        IF_PCnext = 32'h00000020;
        @(posedge clk);
        #1;


        ID_stall = 1;
        IF_flush = 1;
        IF_inst = 32'h99999999;
        IF_PCnext = 32'h00000024;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multi-cycle Flow", test_num);
        reset_dut();


        IF_inst = 32'h00000001;
        IF_PCnext = 32'h4;
        @(posedge clk);
        #1;


        IF_inst = 32'h00000002;
        IF_PCnext = 32'h8;
        @(posedge clk);
        #1;


        IF_inst = 32'h00000003;
        IF_PCnext = 32'hC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hC, 32'h00000003);
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
        input [31:0] expected_ID_PCnext;
        input [31:0] expected_ID_inst;
        begin
            if (expected_ID_PCnext === (expected_ID_PCnext ^ ID_PCnext ^ expected_ID_PCnext) &&
                expected_ID_inst === (expected_ID_inst ^ ID_inst ^ expected_ID_inst)) begin
                $display("PASS");
                $display("  Outputs: ID_PCnext=%h, ID_inst=%h",
                         ID_PCnext, ID_inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_PCnext=%h, ID_inst=%h",
                         expected_ID_PCnext, expected_ID_inst);
                $display("  Got:      ID_PCnext=%h, ID_inst=%h",
                         ID_PCnext, ID_inst);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ID_stall, IF_PC, IF_PCnext, IF_flush, IF_inst, IF_stall, clk, rst, ID_PCnext, ID_inst);
    end

endmodule
