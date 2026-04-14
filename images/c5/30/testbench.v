`timescale 1ns/1ps

module arithmetic_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;
    wire [31:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arithmetic_module dut (
        .a(a),
        .b(b),
        .op(op),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - Positive + Positive", test_num);
            a = 32'd100;
            b = 32'd200;
            op = 2'b00;
            #1;

            check_outputs(32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - Negative + Positive", test_num);
            a = -32'sd50;
            b = 32'sd30;
            op = 2'b00;
            #1;

            check_outputs(-32'sd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - Negative + Negative", test_num);
            a = -32'sd10;
            b = -32'sd20;
            op = 2'b00;
            #1;

            check_outputs(-32'sd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction - Positive - Positive", test_num);
            a = 32'd100;
            b = 32'd40;
            op = 2'b01;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction - Positive - Negative", test_num);
            a = 32'sd20;
            b = -32'sd50;
            op = 2'b01;
            #1;

            check_outputs(32'sd70);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication - Positive * Positive", test_num);
            a = 32'd15;
            b = 32'd10;
            op = 2'b10;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication - Negative * Positive", test_num);
            a = -32'sd10;
            b = 32'sd8;
            op = 2'b10;
            #1;

            check_outputs(-32'sd80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication - Negative * Negative", test_num);
            a = -32'sd5;
            b = -32'sd5;
            op = 2'b10;
            #1;

            check_outputs(32'sd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division - Positive / Positive", test_num);
            a = 32'sd100;
            b = 32'sd10;
            op = 2'b11;
            #1;

            check_outputs(32'sd10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division - Negative / Positive", test_num);
            a = -32'sd50;
            b = 32'sd5;
            op = 2'b11;
            #1;

            check_outputs(-32'sd10);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division - Positive / Negative (Truncation check)", test_num);
            a = 32'sd25;
            b = -32'sd4;
            op = 2'b11;
            #1;

            check_outputs(-32'sd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arithmetic_module Testbench");
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
        input [31:0] expected_c;
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
