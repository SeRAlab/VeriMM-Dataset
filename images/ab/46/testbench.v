`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] op;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        op = 4'd0; a = 32'h0000000A; b = 32'h00000014;
        $display("Test %0d: Addition (10 + 20)", test_num);
        #1;

        check_outputs(32'h0000001E);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op = 4'd1; a = 32'h00000064; b = 32'h0000000A;
        $display("Test %0d: Subtraction (100 - 10)", test_num);
        #1;

        check_outputs(32'h0000005A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op = 4'd2; a = 32'hFFFF0000; b = 32'hF0F0F0F0;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hF0F00000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op = 4'd3; a = 32'hAAAA5555; b = 32'h5555AAAA;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op = 4'd4; a = 32'hF0F0F0F0; b = 32'hAAAAAAAA;
        $display("Test %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(32'h5A5A5A5A);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op = 4'd5; a = 32'h00000001; b = 32'd4;
        $display("Test %0d: SLL (1 << 4)", test_num);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op = 4'd6; a = 32'h80000000; b = 32'd2;
        $display("Test %0d: SRL (0x80000000 >> 2)", test_num);
        #1;

        check_outputs(32'h20000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        op = 4'd7; a = 32'hF0000000; b = 32'd4;
        $display("Test %0d: SRA (Sign preservation)", test_num);
        #1;

        check_outputs(32'hFF000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        op = 4'd8; a = 32'hFFFFFFFF; b = 32'h00000001;
        $display("Test %0d: SLT (-1 < 1)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        op = 4'd9; a = 32'h00000005; b = 32'h00000005;
        $display("Test %0d: SLE (5 <= 5)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        op = 4'd10; a = 32'h12345678; b = 32'h12345678;
        $display("Test %0d: Equality Check", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        op = 4'd11; a = 32'hDEADBEEF; b = 32'h0;
        $display("Test %0d: Move Operation", test_num);
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        op = 4'd12; a = 32'hFFFF8888; b = 32'h0;
        $display("Test %0d: Zero Extend (Lower 16 bits)", test_num);
        #1;

        check_outputs(32'h00008888);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        op = 4'd13; a = 32'h0000AAAA; b = 32'h0000BBBB;
        $display("Test %0d: Concatenate {a[15:0], b[15:0]}", test_num);
        #1;

        check_outputs(32'hAAAABBBB);
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
