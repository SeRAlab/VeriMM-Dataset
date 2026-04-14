`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            $display("Test Case %0d: Adding zero to zero (A=%d, B=%d)", test_num, A, B);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            $display("Test Case %0d: Basic addition (A=%d, B=%d)", test_num, A, B);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd5;
            $display("Test Case %0d: Max result without overflow (A=%d, B=%d)", test_num, A, B);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd1;
            $display("Test Case %0d: Overflow check - single bit wrap (A=%d, B=%d)", test_num, A, B);


            #1;



            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd8;
            $display("Test Case %0d: Mid-range sum (A=%d, B=%d)", test_num, A, B);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b1010;
            $display("Test Case %0d: Addition with internal carry (A=%d, B=%d)", test_num, A, B);

            #1;


            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b1111;
            $display("Test Case %0d: Maximum overflow (A=%d, B=%d)", test_num, A, B);

            #1;


            check_outputs(4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b0001;
            B = 4'b1110;
            $display("Test Case %0d: Result 1111 (A=%d, B=%d)", test_num, A, B);
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
