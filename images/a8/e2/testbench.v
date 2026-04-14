`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] SEL;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (10 + 20)", test_num);
            SEL = 2'b00;
            A = 8'd10;
            B = 8'd20;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (250 + 10)", test_num);
            SEL = 2'b00;
            A = 8'd250;
            B = 8'd10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            SEL = 2'b01;
            A = 8'd50;
            B = 8'd20;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (10 - 20)", test_num);
            SEL = 2'b01;
            A = 8'd10;
            B = 8'd20;
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (12 * 5)", test_num);
            SEL = 2'b10;
            A = 8'd12;
            B = 8'd5;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow (40 * 10)", test_num);
            SEL = 2'b10;
            A = 8'd40;
            B = 8'd10;
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (100 / 4)", test_num);
            SEL = 2'b11;
            A = 8'd100;
            B = 8'd4;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division Truncation (10 / 3)", test_num);
            SEL = 2'b11;
            A = 8'd10;
            B = 8'd3;
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division result 0 (5 / 10)", test_num);
            SEL = 2'b11;
            A = 8'd5;
            B = 8'd10;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Inputs (0 op 0)", test_num);
            A = 8'd0;
            B = 8'd0;

            SEL = 2'b00;
            #1; if (OUT === 8'd0) pass_count++; else fail_count++;

            SEL = 2'b10;
            #1; if (OUT === 8'd0) pass_count++; else fail_count++;

            $display("  Checked Sum and Product with zeros.");
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
        input [7:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
