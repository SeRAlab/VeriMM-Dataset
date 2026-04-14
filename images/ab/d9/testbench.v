`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [1:0] COMP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .COMP(COMP)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: A=0, B=0 (Equality)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: A=15, B=15 (Equality Max)", test_num);
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: A=5, B=5 (Equality Mid)", test_num);
            A = 4'd5;
            B = 4'd5;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: A=1, B=0 (A > B)", test_num);
            A = 4'd1;
            B = 4'd0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: A=15, B=0 (A > B Extremes)", test_num);
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: A=10, B=7 (A > B Mid)", test_num);
            A = 4'd10;
            B = 4'd7;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: A=0, B=1 (A < B)", test_num);
            A = 4'd0;
            B = 4'd1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: A=0, B=15 (A < B Extremes)", test_num);
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: A=3, B=12 (A < B Mid)", test_num);
            A = 4'd3;
            B = 4'd12;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: A=8, B=7 (Boundary check MSB set)", test_num);
            A = 4'd8;
            B = 4'd7;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: A=7, B=8 (Boundary check MSB set)", test_num);
            A = 4'd7;
            B = 4'd8;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_COMP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COMP === (expected_COMP ^ COMP ^ expected_COMP)) begin
                $display("PASS");
                $display("  Outputs: COMP=%h",
                         COMP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COMP=%h",
                         expected_COMP);
                $display("  Got:      COMP=%h",
                         COMP);
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
