`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    wire greater_than;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .greater_than(greater_than),
        .match(match)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'h5; B = 4'h5; C = 4'h2; D = 4'h2;
            $display("Test %0d: All inputs equal (A=B, C=D)", test_num);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'hA; B = 4'hA; C = 4'hF; D = 4'h0;
            $display("Test %0d: A=B but C > D", test_num);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'hA; B = 4'hA; C = 4'h0; D = 4'hF;
            $display("Test %0d: A=B but C < D", test_num);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'h9; B = 4'h1; C = 4'h0; D = 4'h0;
            $display("Test %0d: A > B, C=D", test_num);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'h2; B = 4'h8; C = 4'hF; D = 4'hF;
            $display("Test %0d: A < B, C=D", test_num);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'h5; B = 4'h4; C = 4'h0; D = 4'hF;
            $display("Test %0d: High nibble A > B dominates even if C < D", test_num);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'h4; B = 4'h5; C = 4'hF; D = 4'h0;
            $display("Test %0d: High nibble A < B dominates even if C > D", test_num);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            $display("Test %0d: All Maximum values", test_num);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            $display("Test %0d: All Zeros", test_num);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'h1; B = 4'h0; C = 4'h0; D = 4'hF;
            $display("Test %0d: Boundary - A is 1 greater, C is 15 smaller", test_num);

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_greater_than;
        input expected_match;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: greater_than=%b, match=%b",
                         greater_than, match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater_than=%b, match=%b",
                         expected_greater_than, expected_match);
                $display("  Got:      greater_than=%b, match=%b",
                         greater_than, match);
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
