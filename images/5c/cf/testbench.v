`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [2:0] ALU_OP;
    reg [3:0] B;
    wire [3:0] F;
    wire OF;
    wire ZF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_OP(ALU_OP),
        .B(B),
        .F(F),
        .OF(OF),
        .ZF(ZF)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'h2; B = 4'h3; ALU_OP = 3'b000;
        #1;

        check_outputs(4'h5, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'h7; B = 4'h1; ALU_OP = 3'b000;
        #1;

        check_outputs(4'h8, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hF; B = 4'h1; ALU_OP = 3'b000;
        #1;

        check_outputs(4'h0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'h5; B = 4'h2; ALU_OP = 3'b001;
        #1;

        check_outputs(4'h3, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'h9; B = 4'h2; ALU_OP = 3'b001;
        #1;

        check_outputs(4'h7, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'hA; B = 4'h7; ALU_OP = 3'b010;
        #1;

        check_outputs(4'h2, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'hA; B = 4'h5; ALU_OP = 3'b011;
        #1;

        check_outputs(4'hF, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'hA; B = 4'hA; ALU_OP = 3'b100;
        #1;

        check_outputs(4'h0, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'h0; B = 4'h0; ALU_OP = 3'b101;
        #1;

        check_outputs(4'hF, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'hF; B = 4'h1; ALU_OP = 3'b110;
        #1;

        check_outputs(4'h1, 1'b0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 4'h1; B = 4'hF; ALU_OP = 3'b110;
        #1;

        check_outputs(4'h0, 1'b0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = 4'h1; B = 4'h2; ALU_OP = 3'b111;
        #1;

        check_outputs(4'h4, 1'b0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        A = 4'h8; B = 4'h1; ALU_OP = 3'b111;
        #1;

        check_outputs(4'h0, 1'b0, 1'b1);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [3:0] expected_F;
        input expected_OF;
        input expected_ZF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_OF === (expected_OF ^ OF ^ expected_OF) &&
                expected_ZF === (expected_ZF ^ ZF ^ expected_ZF)) begin
                $display("PASS");
                $display("  Outputs: F=%h, OF=%b, ZF=%b",
                         F, OF, ZF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h, OF=%b, ZF=%b",
                         expected_F, expected_OF, expected_ZF);
                $display("  Got:      F=%h, OF=%b, ZF=%b",
                         F, OF, ZF);
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
