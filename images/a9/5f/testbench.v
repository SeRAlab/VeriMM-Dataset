`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    wire Y0;
    wire Y1;

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
        .Y0(Y0),
        .Y1(Y1)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'b0000; B = 4'b0000; C = 4'b0000; D = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'b0001; B = 4'b0000; C = 4'b0000; D = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'b0000; B = 4'b1000; C = 4'b0000; D = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b0000; B = 4'b0000; C = 4'b0010; D = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b0000; B = 4'b0000; C = 4'b0000; D = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b0101; B = 4'b0000; C = 4'b1010; D = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b0000; B = 4'b1111; C = 4'b0000; D = 4'b0001;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b0011; B = 4'b1100; C = 4'b0000; D = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b0000; B = 4'b0000; C = 4'b1111; D = 4'b1111;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'b1111; B = 4'b1111; C = 4'b1111; D = 4'b1111;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_Y0;
        input expected_Y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y1=%b",
                         Y0, Y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y1=%b",
                         expected_Y0, expected_Y1);
                $display("  Got:      Y0=%b, Y1=%b",
                         Y0, Y1);
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
