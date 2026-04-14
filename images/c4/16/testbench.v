`timescale 1ns/1ps

module simple_arithmetic_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] op;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_arithmetic dut (
        .A(A),
        .B(B),
        .op(op),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10;
            B = 8'd20;
            op = 2'b00;
            $display("Test %0d: Addition (10 + 20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hFF;
            B = 8'h01;
            op = 2'b00;
            $display("Test %0d: Addition wrap-around (0xFF + 0x01)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd50;
            B = 8'd10;
            op = 2'b01;
            $display("Test %0d: Subtraction (50 - 10)", test_num);
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h00;
            B = 8'h01;
            op = 2'b01;
            $display("Test %0d: Subtraction underflow (0x00 - 0x01)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'b10101010;
            B = 8'b11110000;
            op = 2'b10;
            $display("Test %0d: Bitwise AND (0xAA & 0xF0)", test_num);
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hFF;
            B = 8'h00;
            op = 2'b10;
            $display("Test %0d: Bitwise AND with zero (0xFF & 0x00)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'b10101010;
            B = 8'b01010101;
            op = 2'b11;
            $display("Test %0d: Bitwise OR (0xAA | 0x55)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hC3;
            B = 8'hC3;
            op = 2'b11;
            $display("Test %0d: Bitwise OR with self (0xC3 | 0xC3)", test_num);
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'hFF;
            B = 8'hFF;
            op = 2'b00;
            $display("Test %0d: Addition of max values (0xFF + 0xFF)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'h00;
            B = 8'h00;
            op = 2'b01;
            $display("Test %0d: Subtraction of zero values (0 - 0)", test_num);
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
        $display("simple_arithmetic Testbench");
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
