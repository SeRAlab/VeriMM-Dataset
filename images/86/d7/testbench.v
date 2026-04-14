`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] opcode;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 32'd100;
        b = 32'd250;
        opcode = 4'b0000;
        #10;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 32'd500;
        b = 32'd150;
        opcode = 4'b0001;
        #10;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 32'hAAAA_5555;
        b = 32'hF0F0_F0F0;
        opcode = 4'b0010;
        #10;
        #1;

        check_outputs(32'hA0A0_5050, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 32'hAAAA_5555;
        b = 32'hF0F0_F0F0;
        opcode = 4'b0011;
        #10;
        #1;

        check_outputs(32'hFAFA_F5F5, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 32'h1234_5678;
        b = 32'h1234_5678;
        opcode = 4'b0100;
        #10;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 32'h0000_0001;
        b = 32'd4;
        opcode = 4'b0101;
        #10;
        #1;

        check_outputs(32'h0000_0010, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 32'hFFFF_FFFF;
        b = 32'h0000_0001;
        opcode = 4'b0000;
        #10;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 32'h0000_000F;
        b = 32'h0000_000F;
        opcode = 4'b1001;
        #10;

        #1;


        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 32'h8000_0000;
        b = 32'd1;
        opcode = 4'b0101;
        #10;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        opcode = 4'b0100;
        #10;
        #1;

        check_outputs(32'hFFFF_FFFF, 1'b0);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
