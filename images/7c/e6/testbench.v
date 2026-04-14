`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] OP;
    reg RESET_B;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .RESET_B(RESET_B),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        RESET_B = 0;
        forever #5 RESET_B = ~RESET_B;
    end

        task reset_dut;

        begin
            A = 8'h00;
            B = 8'h00;
            OP = 3'b000;

            wait(RESET_B == 0);
            #10;

            wait(RESET_B == 1);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'd25;
            B = 8'd10;
            OP = 3'b000;
            #10;
            $display("Test %0d: Addition (25 + 10)", test_num);
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'd50;
            B = 8'd20;
            OP = 3'b001;
            #10;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'hAA;
            B = 8'hF0;
            OP = 3'b010;
            #10;
            $display("Test %0d: Bitwise AND (AA & F0)", test_num);
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'h55;
            B = 8'h0F;
            OP = 3'b011;
            #10;
            $display("Test %0d: Bitwise OR (55 | 0F)", test_num);
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'hFF;
            B = 8'hAA;
            OP = 3'b100;
            #10;
            $display("Test %0d: Bitwise XOR (FF ^ AA)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'b00001111;
            B = 8'd1;
            OP = 3'b101;
            #10;
            $display("Test %0d: Left Shift", test_num);

            #1;


            check_outputs(8'b00011110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'b11110000;
            B = 8'd1;
            OP = 3'b110;
            #10;
            $display("Test %0d: Right Shift", test_num);
            #1;

            check_outputs(8'b01111000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 8'h00;
            OP = 3'b111;
            #10;
            $display("Test %0d: Bitwise NOT (~00)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;

            A = 8'hFF;
            B = 8'hFF;
            OP = 3'b000;
            wait(RESET_B == 0);
            #2;
            $display("Test %0d: Reset Trigger Check (Output should be 0)", test_num);
            #1;

            check_outputs(8'h00);
            wait(RESET_B == 1);
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
        input [7:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, OP, RESET_B, C);
    end

endmodule
