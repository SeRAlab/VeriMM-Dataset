`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C0;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C0(C0),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0; B = 4'd0; C0 = 0;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Zero check)", test_num, A, B, C0);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd5; B = 4'd3; C0 = 0;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Simple addition)", test_num, A, B, C0);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd5; B = 4'd3; C0 = 1;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Addition with Carry-in)", test_num, A, B, C0);
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd15; B = 4'd0; C0 = 0;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Boundary check)", test_num, A, B, C0);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd15; B = 4'd1; C0 = 0;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Overflow to 16)", test_num, A, B, C0);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd15; B = 4'd15; C0 = 1;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Max value overflow)", test_num, A, B, C0);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd8; B = 4'd8; C0 = 0;
            $display("Test Case %0d: A=%d, B=%d, C0=%b (Power of 2 overflow)", test_num, A, B, C0);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b1010; B = 4'b0101; C0 = 0;
            $display("Test Case %0d: A=%b, B=%b, C0=%b (Bitwise pattern)", test_num, A, B, C0);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b1010; B = 4'b0101; C0 = 1;
            $display("Test Case %0d: A=%b, B=%b, C0=%b (Bitwise pattern + C0)", test_num, A, B, C0);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd7; B = 4'd2; C0 = 0;
            $display("Test Case %0d: A=%d, B=%d, C0=%b", test_num, A, B, C0);
            #1;

            check_outputs(4'd9);
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
        input [3:0] expected_OUT;
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
