`timescale 1ns/1ps

module my_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [3:0] E;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .X(X)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small values, no sum overflow", test_num);
            A = 4'd1; B = 4'd2; C = 4'd3; D = 4'd1; E = 4'd1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only one input active", test_num);
            A = 4'd5; B = 4'd0; C = 4'd0; D = 4'd0; E = 4'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum overflow (wraps to 0)", test_num);
            A = 4'd8; B = 4'd8; C = 4'd0; D = 4'd0; E = 4'd0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            A = 4'd0; B = 4'd0; C = 4'd0; D = 4'd0; E = 4'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs at max value (15)", test_num);
            A = 4'd15; B = 4'd15; C = 4'd15; D = 4'd15; E = 4'd15;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum overflow, but result stays larger than max", test_num);
            A = 4'd10; B = 4'd10; C = 4'd10; D = 4'd0; E = 4'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple inputs share the max value", test_num);
            A = 4'd7; B = 4'd7; C = 4'd2; D = 4'd0; E = 4'd0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High individual values, no overflow", test_num);
            A = 4'd2; B = 4'd2; C = 4'd2; D = 4'd2; E = 4'd2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("my_module Testbench");
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
