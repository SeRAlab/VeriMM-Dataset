`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] opcode;
    wire F;
    wire [31:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .F(F),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Basic (10 + 20)", test_num);
            A = 32'd10;
            B = 32'd20;
            opcode = 2'b00;
            #1;

            check_outputs(1'b0, 32'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Overflow (Max + 1)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            opcode = 2'b00;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Basic (50 - 20)", test_num);
            A = 32'd50;
            B = 32'd20;
            opcode = 2'b01;
            #1;

            check_outputs(1'b0, 32'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Underflow (10 - 20)", test_num);
            A = 32'd10;
            B = 32'd20;
            opcode = 2'b01;

            #1;


            check_outputs(1'b1, 32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Result Zero", test_num);
            A = 32'd100;
            B = 32'd100;
            opcode = 2'b01;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication - Basic (12 * 12)", test_num);
            A = 32'd12;
            B = 32'd12;
            opcode = 2'b10;
            #1;

            check_outputs(1'b0, 32'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication - Overflow", test_num);

            A = 32'h00010000;
            B = 32'h00010000;
            opcode = 2'b10;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication - By Zero", test_num);
            A = 32'hABCD1234;
            B = 32'd0;
            opcode = 2'b10;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division - Basic (100 / 4)", test_num);
            A = 32'd100;
            B = 32'd4;
            opcode = 2'b11;
            #1;

            check_outputs(1'b0, 32'd25);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division - Division by Zero", test_num);
            A = 32'd500;
            B = 32'd0;
            opcode = 2'b11;

            #1;


            check_outputs(1'b1, R);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division - Result Less Than One (5 / 10)", test_num);
            A = 32'd5;
            B = 32'd10;
            opcode = 2'b11;
            #1;

            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Maximum Result (No Overflow)", test_num);
            A = 32'hFFFFFFFE;
            B = 32'h00000001;
            opcode = 2'b00;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
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
        input expected_F;
        input [31:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: F=%b, R=%h",
                         F, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b, R=%h",
                         expected_F, expected_R);
                $display("  Got:      F=%b, R=%h",
                         F, R);
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
