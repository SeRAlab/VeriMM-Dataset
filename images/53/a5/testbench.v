`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] control;
    wire [31:0] ALUResult;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .control(control),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: bitwise AND", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'hFFFF_FFFF;
            control = 3'b000;
            #1;

            check_outputs(32'hAAAA_AAAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: bitwise OR", test_num);
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            control = 3'b001;
            #1;

            check_outputs(32'h9775_5779, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition", test_num);
            A = 32'd1500;
            B = 32'd2500;
            control = 3'b010;
            #1;

            check_outputs(32'd4000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (Positive result)", test_num);
            A = 32'd5000;
            B = 32'd2000;
            control = 3'b110;
            #1;

            check_outputs(32'd3000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (Zero result)", test_num);
            A = 32'hDEAD_BEEF;
            B = 32'hDEAD_BEEF;
            control = 3'b110;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (True)", test_num);
            A = 32'd10;
            B = 32'd20;
            control = 3'b111;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (False)", test_num);
            A = 32'd100;
            B = 32'd50;
            control = 3'b111;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: bitwise XOR", test_num);
            A = 32'hFFFF_0000;
            B = 32'hF0F0_F0F0;
            control = 3'b011;
            #1;

            check_outputs(32'h0F0F_F0F0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: bitwise NOR", test_num);
            A = 32'h0000_FFFF;
            B = 32'h00FF_00FF;
            control = 3'b100;
            #1;

            check_outputs(32'hFF00_0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Overflow/Wrap)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            control = 3'b010;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
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
        input [31:0] expected_ALUResult;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUResult === (expected_ALUResult ^ ALUResult ^ expected_ALUResult) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALUResult=%h, Zero=%b",
                         ALUResult, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult=%h, Zero=%b",
                         expected_ALUResult, expected_Zero);
                $display("  Got:      ALUResult=%h, Zero=%b",
                         ALUResult, Zero);
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
