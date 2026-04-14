`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [9:0] instr;
    reg sclkPosEdge;
    wire cs;
    wire dc;
    wire delayEn;
    wire [7:0] parallelData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instr(instr),
        .sclkPosEdge(sclkPosEdge),
        .cs(cs),
        .dc(dc),
        .delayEn(delayEn),
        .parallelData(parallelData)
    );
    task testcase001;

    begin
        test_num = 1;

        instr = 10'b0;
        sclkPosEdge = 0;
        @(posedge clk);


        instr = {2'b00, 8'hA5};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;


        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        instr = 10'b0;
        sclkPosEdge = 0;
        @(posedge clk);


        instr = {2'b01, 8'h5A};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        instr = 10'b0;
        sclkPosEdge = 0;
        @(posedge clk);


        instr = {2'b10, 8'hFF};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, dc, 1'b1, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        instr = 10'b0;
        sclkPosEdge = 0;
        @(posedge clk);

        instr = {2'b01, 8'hC3};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 8'hC3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        instr = 10'b0;
        sclkPosEdge = 0;
        @(posedge clk);

        instr = {2'b00, 8'h00};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        instr = {2'b00, 8'h11};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;
        repeat(2) @(posedge clk);


        instr = {2'b01, 8'h22};
        sclkPosEdge = 1;
        @(posedge clk);
        sclkPosEdge = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 8'h22);
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
        input expected_cs;
        input expected_dc;
        input expected_delayEn;
        input [7:0] expected_parallelData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_dc === (expected_dc ^ dc ^ expected_dc) &&
                expected_delayEn === (expected_delayEn ^ delayEn ^ expected_delayEn) &&
                expected_parallelData === (expected_parallelData ^ parallelData ^ expected_parallelData)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, dc=%b, delayEn=%b, parallelData=%h",
                         cs, dc, delayEn, parallelData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, dc=%b, delayEn=%b, parallelData=%h",
                         expected_cs, expected_dc, expected_delayEn, expected_parallelData);
                $display("  Got:      cs=%b, dc=%b, delayEn=%b, parallelData=%h",
                         cs, dc, delayEn, parallelData);
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
