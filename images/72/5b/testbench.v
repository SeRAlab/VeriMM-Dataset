`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] imemout;
    wire aluop;
    wire alusrc;
    wire brnch;
    wire memoryread;
    wire memorywrite;
    wire memtoreg;
    wire regdst;
    wire regw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imemout(imemout),
        .aluop(aluop),
        .alusrc(alusrc),
        .brnch(brnch),
        .memoryread(memoryread),
        .memorywrite(memorywrite),
        .memtoreg(memtoreg),
        .regdst(regdst),
        .regw(regw)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: R-type Instruction (Opcode: 000000)", test_num);

        imemout = 6'b000000;
        #1;

        check_outputs(
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            1
        );
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Load Word Instruction (Opcode: 100011)", test_num);

        imemout = 6'b100011;
        #1;

        check_outputs(
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1
        );
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Store Word Instruction (Opcode: 101011)", test_num);

        imemout = 6'b101011;
        #1;

        check_outputs(
            0,
            1,
            0,
            0,
            1,
            0,
            0,
            0
        );
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Branch Equal Instruction (Opcode: 000100)", test_num);

        imemout = 6'b000100;
        #1;

        check_outputs(
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0
        );
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
        input expected_aluop;
        input expected_alusrc;
        input expected_brnch;
        input expected_memoryread;
        input expected_memorywrite;
        input expected_memtoreg;
        input expected_regdst;
        input expected_regw;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluop === (expected_aluop ^ aluop ^ expected_aluop) &&
                expected_alusrc === (expected_alusrc ^ alusrc ^ expected_alusrc) &&
                expected_brnch === (expected_brnch ^ brnch ^ expected_brnch) &&
                expected_memoryread === (expected_memoryread ^ memoryread ^ expected_memoryread) &&
                expected_memorywrite === (expected_memorywrite ^ memorywrite ^ expected_memorywrite) &&
                expected_memtoreg === (expected_memtoreg ^ memtoreg ^ expected_memtoreg) &&
                expected_regdst === (expected_regdst ^ regdst ^ expected_regdst) &&
                expected_regw === (expected_regw ^ regw ^ expected_regw)) begin
                $display("PASS");
                $display("  Outputs: aluop=%b, alusrc=%b, brnch=%b, memoryread=%b, memorywrite=%b, memtoreg=%b, regdst=%b, regw=%b",
                         aluop, alusrc, brnch, memoryread, memorywrite, memtoreg, regdst, regw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluop=%b, alusrc=%b, brnch=%b, memoryread=%b, memorywrite=%b, memtoreg=%b, regdst=%b, regw=%b",
                         expected_aluop, expected_alusrc, expected_brnch, expected_memoryread, expected_memorywrite, expected_memtoreg, expected_regdst, expected_regw);
                $display("  Got:      aluop=%b, alusrc=%b, brnch=%b, memoryread=%b, memorywrite=%b, memtoreg=%b, regdst=%b, regw=%b",
                         aluop, alusrc, brnch, memoryread, memorywrite, memtoreg, regdst, regw);
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
