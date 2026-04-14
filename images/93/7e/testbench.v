`timescale 1ns/1ps

module alu_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] control;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_8bit dut (
        .a(a),
        .b(b),
        .control(control),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Addition (5 + 3)", test_num);
            a = 8'h05;
            b = 8'h03;
            control = 3'b000;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Addition Overflow (255 + 1)", test_num);
            a = 8'hFF;
            b = 8'h01;
            control = 3'b000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Subtraction (10 - 4)", test_num);
            a = 8'h0A;
            b = 8'h04;
            control = 3'b001;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Subtraction Underflow (0 - 1)", test_num);
            a = 8'h00;
            b = 8'h01;
            control = 3'b001;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Bitwise AND (0xAA & 0x55)", test_num);
            a = 8'hAA;
            b = 8'h55;
            control = 3'b010;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Bitwise AND (0xFF & 0x0F)", test_num);
            a = 8'hFF;
            b = 8'h0F;
            control = 3'b010;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Bitwise OR (0x55 | 0xAA)", test_num);
            a = 8'h55;
            b = 8'hAA;
            control = 3'b011;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Bitwise OR (0xF0 | 0x00)", test_num);
            a = 8'hF0;
            b = 8'h00;
            control = 3'b011;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Bitwise XOR (0xAA ^ 0x55)", test_num);
            a = 8'hAA;
            b = 8'h55;
            control = 3'b100;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Bitwise XOR (0xFF ^ 0xFF)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            control = 3'b100;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_8bit Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
