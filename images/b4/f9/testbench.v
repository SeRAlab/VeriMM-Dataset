`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [1:0] op;
    wire [15:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Addition", test_num);
            a = 16'h0A80;
            b = 16'h0440;
            op = 2'b00;
            #1;

            check_outputs(16'h0EC0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed Addition", test_num);
            a = 16'hFB00;
            b = 16'h0200;
            op = 2'b00;
            #1;

            check_outputs(16'hFD00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Saturation (Positive)", test_num);
            a = 16'h7F00;
            b = 16'h0200;
            op = 2'b00;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction", test_num);
            a = 16'h1400;
            b = 16'h0580;
            op = 2'b01;
            #1;

            check_outputs(16'h0E80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Saturation (Negative)", test_num);
            a = 16'h8100;
            b = 16'h0100;
            op = 2'b01;


            a = 16'h8000; b = 16'h0001;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Basic", test_num);
            a = 16'h0200;
            b = 16'h0300;
            op = 2'b10;
            #1;

            check_outputs(16'h0600);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Fractional", test_num);
            a = 16'h0080;
            b = 16'h0080;
            op = 2'b10;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Signed", test_num);
            a = 16'h0200;
            b = 16'hFF00;
            op = 2'b10;
            #1;

            check_outputs(16'hFE00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division Basic", test_num);
            a = 16'h0A00;
            b = 16'h0200;
            op = 2'b11;
            #1;

            check_outputs(16'h0500);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero", test_num);
            a = 16'h0100;
            b = 16'h0000;
            op = 2'b11;

            #1;


            check_outputs(16'h7FFF);
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
        input [15:0] expected_c;
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
