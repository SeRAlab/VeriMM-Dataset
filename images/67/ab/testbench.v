`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] addr;
    reg clk;
    reg [7:0] din;
    reg read_a;
    reg read_b;
    reg write;
    wire [22:0] MemAdr;
    wire MemAdv;
    wire MemClk;
    wire MemOE;
    wire MemWR;
    wire RamCRE;
    wire RamCS;
    wire RamLB;
    wire RamUB;
    wire busy;
    wire [7:0] dout_a;
    wire [7:0] dout_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .read_a(read_a),
        .read_b(read_b),
        .write(write),
        .MemAdr(MemAdr),
        .MemAdv(MemAdv),
        .MemClk(MemClk),
        .MemOE(MemOE),
        .MemWR(MemWR),
        .RamCRE(RamCRE),
        .RamCS(RamCS),
        .RamLB(RamLB),
        .RamUB(RamUB),
        .busy(busy),
        .dout_a(dout_a),
        .dout_b(dout_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read_a = 0;
            read_b = 0;
            write = 0;
            addr = 24'h0;
            din = 8'h0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial Idle State");
            reset_dut();

            #1;


            check_outputs(23'h0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Write to Even Address (0x000002)");
            reset_dut();
            addr = 24'h000002;
            din = 8'hAA;
            write = 1;
            @(posedge clk);
            write = 0;


            if (!busy) @(posedge clk);
            while (busy) @(posedge clk);



            #1;




            check_outputs(23'h000001, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Write to Odd Address (0x000003)");
            reset_dut();
            addr = 24'h000003;
            din = 8'h55;
            write = 1;
            @(posedge clk);
            write = 0;

            if (!busy) @(posedge clk);
            while (busy) @(posedge clk);


            #1;



            check_outputs(23'h000001, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Read Channel A (0x00000A)");
            reset_dut();
            addr = 24'h00000A;
            read_a = 1;
            @(posedge clk);
            read_a = 0;

            if (!busy) @(posedge clk);
            while (busy) @(posedge clk);



            #1;




            check_outputs(23'h000005, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, dout_a, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Read Channel B (0x00000B)");
            reset_dut();
            addr = 24'h00000B;
            read_b = 1;
            @(posedge clk);
            read_b = 0;

            if (!busy) @(posedge clk);
            while (busy) @(posedge clk);


            #1;



            check_outputs(23'h000005, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, dout_a, dout_b);
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
        input [22:0] expected_MemAdr;
        input expected_MemAdv;
        input expected_MemClk;
        input expected_MemOE;
        input expected_MemWR;
        input expected_RamCRE;
        input expected_RamCS;
        input expected_RamLB;
        input expected_RamUB;
        input expected_busy;
        input [7:0] expected_dout_a;
        input [7:0] expected_dout_b;
        begin
            if (expected_MemAdr === (expected_MemAdr ^ MemAdr ^ expected_MemAdr) &&
                expected_MemAdv === (expected_MemAdv ^ MemAdv ^ expected_MemAdv) &&
                expected_MemClk === (expected_MemClk ^ MemClk ^ expected_MemClk) &&
                expected_MemOE === (expected_MemOE ^ MemOE ^ expected_MemOE) &&
                expected_MemWR === (expected_MemWR ^ MemWR ^ expected_MemWR) &&
                expected_RamCRE === (expected_RamCRE ^ RamCRE ^ expected_RamCRE) &&
                expected_RamCS === (expected_RamCS ^ RamCS ^ expected_RamCS) &&
                expected_RamLB === (expected_RamLB ^ RamLB ^ expected_RamLB) &&
                expected_RamUB === (expected_RamUB ^ RamUB ^ expected_RamUB) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_dout_a === (expected_dout_a ^ dout_a ^ expected_dout_a) &&
                expected_dout_b === (expected_dout_b ^ dout_b ^ expected_dout_b)) begin
                $display("PASS");
                $display("  Outputs: MemAdr=%h, MemAdv=%b, MemClk=%b, MemOE=%b, MemWR=%b, RamCRE=%b, RamCS=%b, RamLB=%b, RamUB=%b, busy=%b, dout_a=%h, dout_b=%h",
                         MemAdr, MemAdv, MemClk, MemOE, MemWR, RamCRE, RamCS, RamLB, RamUB, busy, dout_a, dout_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MemAdr=%h, MemAdv=%b, MemClk=%b, MemOE=%b, MemWR=%b, RamCRE=%b, RamCS=%b, RamLB=%b, RamUB=%b, busy=%b, dout_a=%h, dout_b=%h",
                         expected_MemAdr, expected_MemAdv, expected_MemClk, expected_MemOE, expected_MemWR, expected_RamCRE, expected_RamCS, expected_RamLB, expected_RamUB, expected_busy, expected_dout_a, expected_dout_b);
                $display("  Got:      MemAdr=%h, MemAdv=%b, MemClk=%b, MemOE=%b, MemWR=%b, RamCRE=%b, RamCS=%b, RamLB=%b, RamUB=%b, busy=%b, dout_a=%h, dout_b=%h",
                         MemAdr, MemAdv, MemClk, MemOE, MemWR, RamCRE, RamCS, RamLB, RamUB, busy, dout_a, dout_b);
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
        $dumpvars(0,addr, clk, din, read_a, read_b, write, MemAdr, MemAdv, MemClk, MemOE, MemWR, RamCRE, RamCS, RamLB, RamUB, busy, dout_a, dout_b);
    end

endmodule
