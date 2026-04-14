`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] flags;
    reg [15:0] ir0q;
    reg [15:0] ir1q;
    reg reset;
    wire [3:0] aluf;
    wire clrIr0;
    wire clrR;
    wire dojump;
    wire gate;
    wire [3:0] readAddrA;
    wire [3:0] readAddrB;
    wire rw;
    wire [1:0] selA;
    wire [1:0] selB;
    wire sel_addr_reg;
    wire wrAddr;
    wire [3:0] writeAddress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flags(flags),
        .ir0q(ir0q),
        .ir1q(ir1q),
        .reset(reset),
        .aluf(aluf),
        .clrIr0(clrIr0),
        .clrR(clrR),
        .dojump(dojump),
        .gate(gate),
        .readAddrA(readAddrA),
        .readAddrB(readAddrB),
        .rw(rw),
        .selA(selA),
        .selB(selB),
        .sel_addr_reg(sel_addr_reg),
        .wrAddr(wrAddr),
        .writeAddress(writeAddress)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: System Reset", test_num);
            reset = 1;
            flags = 4'b0000;
            ir0q = 16'h0000;
            ir1q = 16'h0000;

            #1;


            check_outputs(4'h0, 1'b1, 1'b1, 1'b0, 1'b0, 4'h0, 4'h0, 1'b0, 2'b00, 2'b00, 1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: ALU ADD Operation (R2 = R3 + R4)", test_num);
            reset = 1; #10; reset = 0;
            flags = 4'b0000;
            ir0q = 16'h1234;
            ir1q = 16'h0000;

            #1;


            check_outputs(4'h1, 1'b0, 1'b0, 1'b0, 1'b1, 4'h3, 4'h4, 1'b0, 2'b00, 2'b00, 1'b0, 1'b1, 4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Load from Memory", test_num);
            reset = 1; #10; reset = 0;
            flags = 4'b0000;
            ir0q = 16'hB500;
            ir1q = 16'hA000;

            #1;


            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b1, 4'h0, 4'h0, 1'b0, 2'b00, 2'b00, 1'b1, 1'b1, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Conditional Jump (JZ) - Condition Met", test_num);
            reset = 1; #10; reset = 0;
            flags = 4'b0001;
            ir0q = 16'h9000;
            ir1q = 16'h1234;

            #1;


            check_outputs(4'h0, 1'b0, 1'b0, 1'b1, 1'b0, 4'h0, 4'h0, 1'b0, 2'b00, 2'b00, 1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Conditional Jump (JZ) - Condition Not Met", test_num);
            reset = 1; #10; reset = 0;
            flags = 4'b0000;
            ir0q = 16'h9000;
            ir1q = 16'h1234;

            #1;


            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 4'h0, 4'h0, 1'b0, 2'b00, 2'b00, 1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: ALU SUB Operation", test_num);
            reset = 1; #10; reset = 0;
            flags = 4'b0000;
            ir0q = 16'h2F12;
            ir1q = 16'h0000;

            #1;


            check_outputs(4'h2, 1'b0, 1'b0, 1'b0, 1'b1, 4'h1, 4'h2, 1'b0, 2'b00, 2'b00, 1'b0, 1'b1, 4'hF);
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
        input [3:0] expected_aluf;
        input expected_clrIr0;
        input expected_clrR;
        input expected_dojump;
        input expected_gate;
        input [3:0] expected_readAddrA;
        input [3:0] expected_readAddrB;
        input expected_rw;
        input [1:0] expected_selA;
        input [1:0] expected_selB;
        input expected_sel_addr_reg;
        input expected_wrAddr;
        input [3:0] expected_writeAddress;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluf === (expected_aluf ^ aluf ^ expected_aluf) &&
                expected_clrIr0 === (expected_clrIr0 ^ clrIr0 ^ expected_clrIr0) &&
                expected_clrR === (expected_clrR ^ clrR ^ expected_clrR) &&
                expected_dojump === (expected_dojump ^ dojump ^ expected_dojump) &&
                expected_gate === (expected_gate ^ gate ^ expected_gate) &&
                expected_readAddrA === (expected_readAddrA ^ readAddrA ^ expected_readAddrA) &&
                expected_readAddrB === (expected_readAddrB ^ readAddrB ^ expected_readAddrB) &&
                expected_rw === (expected_rw ^ rw ^ expected_rw) &&
                expected_selA === (expected_selA ^ selA ^ expected_selA) &&
                expected_selB === (expected_selB ^ selB ^ expected_selB) &&
                expected_sel_addr_reg === (expected_sel_addr_reg ^ sel_addr_reg ^ expected_sel_addr_reg) &&
                expected_wrAddr === (expected_wrAddr ^ wrAddr ^ expected_wrAddr) &&
                expected_writeAddress === (expected_writeAddress ^ writeAddress ^ expected_writeAddress)) begin
                $display("PASS");
                $display("  Outputs: aluf=%h, clrIr0=%b, clrR=%b, dojump=%b, gate=%b, readAddrA=%h, readAddrB=%h, rw=%b, selA=%h, selB=%h, sel_addr_reg=%b, wrAddr=%b, writeAddress=%h",
                         aluf, clrIr0, clrR, dojump, gate, readAddrA, readAddrB, rw, selA, selB, sel_addr_reg, wrAddr, writeAddress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluf=%h, clrIr0=%b, clrR=%b, dojump=%b, gate=%b, readAddrA=%h, readAddrB=%h, rw=%b, selA=%h, selB=%h, sel_addr_reg=%b, wrAddr=%b, writeAddress=%h",
                         expected_aluf, expected_clrIr0, expected_clrR, expected_dojump, expected_gate, expected_readAddrA, expected_readAddrB, expected_rw, expected_selA, expected_selB, expected_sel_addr_reg, expected_wrAddr, expected_writeAddress);
                $display("  Got:      aluf=%h, clrIr0=%b, clrR=%b, dojump=%b, gate=%b, readAddrA=%h, readAddrB=%h, rw=%b, selA=%h, selB=%h, sel_addr_reg=%b, wrAddr=%b, writeAddress=%h",
                         aluf, clrIr0, clrR, dojump, gate, readAddrA, readAddrB, rw, selA, selB, sel_addr_reg, wrAddr, writeAddress);
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
