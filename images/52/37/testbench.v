`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_a;
    reg [31:0] alu_b;
    reg [5:0] alu_op;
    wire [31:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_a(alu_a),
        .alu_b(alu_b),
        .alu_op(alu_op),
        .alu_out(alu_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (Positive)", test_num);
        alu_a  = 32'd150;
        alu_b  = 32'd250;
        alu_op = OP_ADD;
        #1;

        check_outputs(32'd400);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (Negative)", test_num);
        alu_a  = -32'd50;
        alu_b  = 32'd20;
        alu_op = OP_ADD;
        #1;

        check_outputs(-32'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction", test_num);
        alu_a  = 32'd1000;
        alu_b  = 32'd400;
        alu_op = OP_SUB;
        #1;

        check_outputs(32'd600);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND", test_num);
        alu_a  = 32'hAAAA_FFFF;
        alu_b  = 32'h5555_FFFF;
        alu_op = OP_AND;
        #1;

        check_outputs(32'h0000_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR", test_num);
        alu_a  = 32'hF0F0_F0F0;
        alu_b  = 32'h0F0F_0F0F;
        alu_op = OP_OR;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR", test_num);
        alu_a  = 32'h1234_5678;
        alu_b  = 32'h1234_5678;
        alu_op = OP_XOR;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise NOR", test_num);
        alu_a  = 32'h0000_0000;
        alu_b  = 32'h0000_0000;
        alu_op = OP_NOR;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NOP (No-Operation)", test_num);
        alu_a  = 32'h1234_5678;
        alu_b  = 32'h8765_4321;
        alu_op = OP_NOP;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (Negative Result)", test_num);
        alu_a  = 32'd10;
        alu_b  = 32'd20;
        alu_op = OP_SUB;
        #1;

        check_outputs(-32'd10);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge Case Wrap Around", test_num);
        alu_a  = 32'h7FFF_FFFF;
        alu_b  = 32'd1;
        alu_op = OP_ADD;
        #1;

        check_outputs(32'h8000_0000);
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
        input [31:0] expected_alu_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
