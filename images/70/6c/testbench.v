`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg B;
    reg C;
    wire D;
    wire [1:0] Z;

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
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0000, B=0, C=0", test_num);
            A = 4'b0000; B = 1'b0; C = 1'b0;

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1111, B=1, C=0", test_num);
            A = 4'b1111; B = 1'b1; C = 1'b0;

            #1;


            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1010, B=0, C=1", test_num);
            A = 4'b1010; B = 1'b0; C = 1'b1;

            #1;


            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0101, B=1, C=1", test_num);
            A = 4'b0101; B = 1'b1; C = 1'b1;

            #1;


            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0010, B=1, C=0", test_num);
            A = 4'b0010; B = 1'b1; C = 1'b0;

            #1;


            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0011, B=0, C=1", test_num);
            A = 4'b0011; B = 1'b0; C = 1'b1;

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1101, B=1, C=1", test_num);
            A = 4'b1101; B = 1'b1; C = 1'b1;

            #1;


            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1000, B=0, C=0", test_num);
            A = 4'b1000; B = 1'b0; C = 1'b0;

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0110, B=1, C=0", test_num);
            A = 4'b0110; B = 1'b1; C = 1'b0;

            #1;


            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1001, B=0, C=1", test_num);
            A = 4'b1001; B = 1'b0; C = 1'b1;

            #1;


            check_outputs(1'b0, 2'b10);
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
        input expected_D;
        input [1:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: D=%b, Z=%h",
                         D, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%b, Z=%h",
                         expected_D, expected_Z);
                $display("  Got:      D=%b, Z=%h",
                         D, Z);
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
