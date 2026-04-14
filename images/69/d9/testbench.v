`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg cin;
    wire [3:0] S;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .cin(cin),
        .S(S),
        .cout(cout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition (no carry)", test_num);
            A = 4'd2;
            B = 4'd3;
            cin = 1'b0;

            #1;


            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition with carry-in", test_num);
            A = 4'd5;
            B = 4'd1;
            cin = 1'b1;

            #1;


            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without carry-out", test_num);
            A = 4'd10;
            B = 4'd5;
            cin = 1'b0;

            #1;


            check_outputs(4'hf, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-out generation (A+B)", test_num);
            A = 4'd8;
            B = 4'd8;
            cin = 1'b0;

            #1;


            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-out generation via cin", test_num);
            A = 4'd15;
            B = 4'd0;
            cin = 1'b1;

            #1;


            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible inputs", test_num);
            A = 4'd15;
            B = 4'd15;
            cin = 1'b1;

            #1;


            check_outputs(4'hf, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            A = 4'd0;
            B = 4'd0;
            cin = 1'b0;

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            A = 4'b1010;
            B = 4'b0101;
            cin = 1'b0;

            #1;


            check_outputs(4'b1111, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits with carry", test_num);
            A = 4'b1010;
            B = 4'b0101;
            cin = 1'b1;

            #1;


            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest overflow", test_num);
            A = 4'd1;
            B = 4'd14;
            cin = 1'b1;

            #1;


            check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_S;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: S=%h, cout=%b",
                         S, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, cout=%b",
                         expected_S, expected_cout);
                $display("  Got:      S=%h, cout=%b",
                         S, cout);
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
