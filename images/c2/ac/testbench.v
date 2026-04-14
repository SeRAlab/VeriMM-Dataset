`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] op;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd15;
            b = 8'd27;
            op = 4'b0000;
            $display("Test %0d: Addition (15 + 27)", test_num);
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd100;
            b = 8'd36;
            op = 4'b0001;
            $display("Test %0d: Subtraction (100 - 36)", test_num);
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'd12;
            b = 8'd8;
            op = 4'b0010;
            $display("Test %0d: Multiplication (12 * 8)", test_num);
            #1;

            check_outputs(8'd96);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd200;
            b = 8'd5;
            op = 4'b0011;
            $display("Test %0d: Division (200 / 5)", test_num);
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'hAA;
            b = 8'hF0;
            op = 4'b0100;
            $display("Test %0d: Bitwise AND (0xAA & 0xF0)", test_num);
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h55;
            b = 8'h0F;
            op = 4'b0101;
            $display("Test %0d: Bitwise OR (0x55 | 0x0F)", test_num);
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'h3C;
            b = 8'h00;
            op = 4'b0110;
            $display("Test %0d: Bitwise NOT (~0x3C)", test_num);
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'd250;
            b = 8'd10;
            op = 4'b0000;
            $display("Test %0d: Addition Overflow (250 + 10)", test_num);
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'd5;
            b = 8'd10;
            op = 4'b0001;
            $display("Test %0d: Subtraction Underflow (5 - 10)", test_num);
            #1;

            check_outputs(8'd251);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'd15;
            b = 8'd4;
            op = 4'b0011;
            $display("Test %0d: Division Remainder (15 / 4)", test_num);
            #1;

            check_outputs(8'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calculator Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
