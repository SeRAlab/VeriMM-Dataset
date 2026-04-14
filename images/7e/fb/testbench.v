`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] code;
    wire [4:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .code(code),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND Operation (1010 & 1100)", test_num);
            code = 2'b00; a = 4'b1010; b = 4'b1100;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND Operation (1111 & 0000)", test_num);
            code = 2'b00; a = 4'b1111; b = 4'b0000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR Operation (1010 | 0101)", test_num);
            code = 2'b01; a = 4'b1010; b = 4'b0101;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR Operation (0000 | 0000)", test_num);
            code = 2'b01; a = 4'b0000; b = 4'b0000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            code = 2'b10; a = 4'd10; b = 4'd4;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (15 - 15)", test_num);
            code = 2'b10; a = 4'd15; b = 4'd15;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
            code = 2'b10; a = 4'd0; b = 4'd1;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 3)", test_num);
            code = 2'b11; a = 4'd5; b = 4'd3;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (15 + 1)", test_num);
            code = 2'b11; a = 4'd15; b = 4'd1;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Max (15 + 15)", test_num);
            code = 2'b11; a = 4'd15; b = 4'd15;
            #1;

            check_outputs(5'd30);
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
        input [4:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
