`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUcontrol;
    reg [31:0] alu_a;
    reg [31:0] alu_b;
    reg rst;
    wire [31:0] alu_out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUcontrol(ALUcontrol),
        .alu_a(alu_a),
        .alu_b(alu_b),
        .rst(rst),
        .alu_out(alu_out),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Logic", test_num);
        rst = 1;
        ALUcontrol = 4'b0010; alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF;
        #10;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (15 + 27)", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0010;
        alu_a = 32'd15;
        alu_b = 32'd27;
        #10;
        #1;

        check_outputs(32'd42, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (100 - 40)", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0110;
        alu_a = 32'd100;
        alu_b = 32'd40;
        #10;
        #1;

        check_outputs(32'd60, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0000;
        alu_a = 32'hF0F0AAAA;
        alu_b = 32'hFFFF0000;
        #10;
        #1;

        check_outputs(32'hF0F00000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0001;
        alu_a = 32'hF0F0AAAA;
        alu_b = 32'h0F0F5555;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR (Identity)", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0011;
        alu_a = 32'h12345678;
        alu_b = 32'h12345678;
        #10;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise NOR", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b1100;
        alu_a = 32'h00000000;
        alu_b = 32'h00000000;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SLT (5 < 10)", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0111;
        alu_a = 32'd5;
        alu_b = 32'd10;
        #10;
        #1;

        check_outputs(32'h1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SLT (20 < 10)", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0111;
        alu_a = 32'd20;
        alu_b = 32'd10;
        #10;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Flag check (50 - 50)", test_num);
        rst = 1; #5; rst = 0;
        ALUcontrol = 4'b0110;
        alu_a = 32'd50;
        alu_b = 32'd50;
        #10;
        #1;

        check_outputs(32'h0, 1'b1);
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
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h, zero=%b",
                         alu_out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h, zero=%b",
                         expected_alu_out, expected_zero);
                $display("  Got:      alu_out=%h, zero=%b",
                         alu_out, zero);
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
