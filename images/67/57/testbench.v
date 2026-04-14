`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] funct;
    reg [1:0] op;
    reg [3:0] rd;
    wire [1:0] alucontrol;
    wire alusrc;
    wire [1:0] flagw;
    wire [1:0] immsrc;
    wire memtoreg;
    wire memw;
    wire nowrite;
    wire pcs;
    wire [1:0] regsrc;
    wire regw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .funct(funct),
        .op(op),
        .rd(rd),
        .alucontrol(alucontrol),
        .alusrc(alusrc),
        .flagw(flagw),
        .immsrc(immsrc),
        .memtoreg(memtoreg),
        .memw(memw),
        .nowrite(nowrite),
        .pcs(pcs),
        .regsrc(regsrc),
        .regw(regw)
    );
    task testcase001;

    begin
        test_num = 1;
        op = 2'b00;
        funct = 6'b001000;
        rd = 4'b0001;

        #1;


        check_outputs(2'b00, 1'b0, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op = 2'b00;
        funct = 6'b100101;
        rd = 4'b0010;

        #1;


        check_outputs(2'b01, 1'b1, 2'b11, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op = 2'b01;
        funct = 6'b011001;
        rd = 4'b0011;

        #1;


        check_outputs(2'b00, 1'b1, 2'b00, 2'b01, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op = 2'b01;
        funct = 6'b011000;
        rd = 4'b0100;

        #1;


        check_outputs(2'b00, 1'b1, 2'b00, 2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b10, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op = 2'b10;
        funct = 6'bXXXXXX;
        rd = 4'b1111;

        #1;


        check_outputs(2'b00, 1'b1, 2'b00, 2'b10, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op = 2'b00;
        funct = 6'b010101;
        rd = 4'b0000;

        #1;


        check_outputs(2'b01, 1'b0, 2'b11, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op = 2'b00;
        funct = 6'b001000;
        rd = 4'b1111;

        #1;


        check_outputs(2'b00, 1'b0, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 2'b00, 1'b1);
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
        input [1:0] expected_alucontrol;
        input expected_alusrc;
        input [1:0] expected_flagw;
        input [1:0] expected_immsrc;
        input expected_memtoreg;
        input expected_memw;
        input expected_nowrite;
        input expected_pcs;
        input [1:0] expected_regsrc;
        input expected_regw;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alucontrol === (expected_alucontrol ^ alucontrol ^ expected_alucontrol) &&
                expected_alusrc === (expected_alusrc ^ alusrc ^ expected_alusrc) &&
                expected_flagw === (expected_flagw ^ flagw ^ expected_flagw) &&
                expected_immsrc === (expected_immsrc ^ immsrc ^ expected_immsrc) &&
                expected_memtoreg === (expected_memtoreg ^ memtoreg ^ expected_memtoreg) &&
                expected_memw === (expected_memw ^ memw ^ expected_memw) &&
                expected_nowrite === (expected_nowrite ^ nowrite ^ expected_nowrite) &&
                expected_pcs === (expected_pcs ^ pcs ^ expected_pcs) &&
                expected_regsrc === (expected_regsrc ^ regsrc ^ expected_regsrc) &&
                expected_regw === (expected_regw ^ regw ^ expected_regw)) begin
                $display("PASS");
                $display("  Outputs: alucontrol=%h, alusrc=%b, flagw=%h, immsrc=%h, memtoreg=%b, memw=%b, nowrite=%b, pcs=%b, regsrc=%h, regw=%b",
                         alucontrol, alusrc, flagw, immsrc, memtoreg, memw, nowrite, pcs, regsrc, regw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alucontrol=%h, alusrc=%b, flagw=%h, immsrc=%h, memtoreg=%b, memw=%b, nowrite=%b, pcs=%b, regsrc=%h, regw=%b",
                         expected_alucontrol, expected_alusrc, expected_flagw, expected_immsrc, expected_memtoreg, expected_memw, expected_nowrite, expected_pcs, expected_regsrc, expected_regw);
                $display("  Got:      alucontrol=%h, alusrc=%b, flagw=%h, immsrc=%h, memtoreg=%b, memw=%b, nowrite=%b, pcs=%b, regsrc=%h, regw=%b",
                         alucontrol, alusrc, flagw, immsrc, memtoreg, memw, nowrite, pcs, regsrc, regw);
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
