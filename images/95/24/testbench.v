`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] insn;
    wire branching;
    wire deref_rhs;
    wire [3:0] idxX;
    wire [3:0] idxY;
    wire [3:0] idxZ;
    wire [1:0] kind;
    wire loading;
    wire [3:0] op;
    wire storing;
    wire [31:0] valI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .insn(insn),
        .branching(branching),
        .deref_rhs(deref_rhs),
        .idxX(idxX),
        .idxY(idxY),
        .idxZ(idxZ),
        .kind(kind),
        .loading(loading),
        .op(op),
        .storing(storing),
        .valI(valI)
    );
    task testcase001;

    begin
        test_num = 1;

        insn = 32'h1234_5ABC_0;
        #1;

        check_outputs(0, 0, 4'hB, 4'hC, 4'hA, 2'b00, 0, 4'h5, 0, 32'h00001234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        insn = 32'h0010_0123_1;
        #1;

        check_outputs(0, 0, 4'h2, 4'h3, 4'h1, 2'b01, 1, 4'h0, 0, 32'h00000010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        insn = 32'h0020_1456_1;
        #1;

        check_outputs(0, 0, 4'h5, 4'h6, 4'h4, 2'b01, 0, 4'h1, 1, 32'h00000020);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        insn = 32'h0000_8789_2;
        #1;

        check_outputs(0, 1, 4'h8, 4'h9, 4'h7, 2'b10, 0, 4'h8, 0, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        insn = 32'h0008_F111_3;
        #1;

        check_outputs(1, 0, 4'h1, 4'h1, 4'h1, 2'b11, 0, 4'hF, 0, 32'h00000008);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        insn = 32'hFFFF_0000_0;
        #1;

        check_outputs(0, 0, 4'h0, 4'h0, 4'h0, 2'b00, 0, 4'h0, 0, 32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        insn = 32'h0ABC_2345_3;

        #1;


        check_outputs(1, 0, 4'h4, 4'h5, 4'h3, 2'b11, 0, 4'h2, 0, 32'h00000ABC);
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
        input expected_branching;
        input expected_deref_rhs;
        input [3:0] expected_idxX;
        input [3:0] expected_idxY;
        input [3:0] expected_idxZ;
        input [1:0] expected_kind;
        input expected_loading;
        input [3:0] expected_op;
        input expected_storing;
        input [31:0] expected_valI;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branching === (expected_branching ^ branching ^ expected_branching) &&
                expected_deref_rhs === (expected_deref_rhs ^ deref_rhs ^ expected_deref_rhs) &&
                expected_idxX === (expected_idxX ^ idxX ^ expected_idxX) &&
                expected_idxY === (expected_idxY ^ idxY ^ expected_idxY) &&
                expected_idxZ === (expected_idxZ ^ idxZ ^ expected_idxZ) &&
                expected_kind === (expected_kind ^ kind ^ expected_kind) &&
                expected_loading === (expected_loading ^ loading ^ expected_loading) &&
                expected_op === (expected_op ^ op ^ expected_op) &&
                expected_storing === (expected_storing ^ storing ^ expected_storing) &&
                expected_valI === (expected_valI ^ valI ^ expected_valI)) begin
                $display("PASS");
                $display("  Outputs: branching=%b, deref_rhs=%b, idxX=%h, idxY=%h, idxZ=%h, kind=%h, loading=%b, op=%h, storing=%b, valI=%h",
                         branching, deref_rhs, idxX, idxY, idxZ, kind, loading, op, storing, valI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branching=%b, deref_rhs=%b, idxX=%h, idxY=%h, idxZ=%h, kind=%h, loading=%b, op=%h, storing=%b, valI=%h",
                         expected_branching, expected_deref_rhs, expected_idxX, expected_idxY, expected_idxZ, expected_kind, expected_loading, expected_op, expected_storing, expected_valI);
                $display("  Got:      branching=%b, deref_rhs=%b, idxX=%h, idxY=%h, idxZ=%h, kind=%h, loading=%b, op=%h, storing=%b, valI=%h",
                         branching, deref_rhs, idxX, idxY, idxZ, kind, loading, op, storing, valI);
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
