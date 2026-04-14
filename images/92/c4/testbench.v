`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg enable;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .enable(enable),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: enable=0, A=3, B=3 (Result should be 0)", test_num);
            enable = 0; A = 2'b11; B = 2'b11;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: enable=1, A=0, B=0 (0*0=0)", test_num);
            enable = 1; A = 2'b00; B = 2'b00;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: enable=1, A=1, B=1 (1*1=1)", test_num);
            enable = 1; A = 2'b01; B = 2'b01;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: enable=1, A=1, B=2 (1*2=2)", test_num);
            enable = 1; A = 2'b01; B = 2'b10;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: enable=1, A=2, B=2 (2*2=4)", test_num);
            enable = 1; A = 2'b10; B = 2'b10;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: enable=1, A=3, B=1 (3*1=3)", test_num);
            enable = 1; A = 2'b11; B = 2'b01;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: enable=1, A=3, B=2 (3*2=6)", test_num);
            enable = 1; A = 2'b11; B = 2'b10;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: enable=1, A=3, B=3 (3*3=9)", test_num);
            enable = 1; A = 2'b11; B = 2'b11;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: enable=0, A=1, B=2 (Enable low check)", test_num);
            enable = 0; A = 2'b01; B = 2'b10;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_result;
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
