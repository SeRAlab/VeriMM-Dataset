`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg E;
    wire z0;
    wire z1;
    wire z2;
    wire z3;
    wire z4;

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
        .E(E),
        .z0(z0),
        .z1(z1),
        .z2(z2),
        .z3(z3),
        .z4(z4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs LOW", test_num);
            A = 0; B = 0; C = 0; D = 0; E = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs HIGH", test_num);
            A = 1; B = 1; C = 1; D = 1; E = 1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating inputs (10101)", test_num);
            A = 1; B = 0; C = 1; D = 0; E = 1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating inputs (01010)", test_num);
            A = 0; B = 1; C = 0; D = 1; E = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High nibble patterns", test_num);
            A = 1; B = 1; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Low nibble patterns", test_num);
            A = 0; B = 0; C = 0; D = 1; E = 1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking bit (A high)", test_num);
            A = 1; B = 0; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking bit (C high)", test_num);
            A = 0; B = 0; C = 1; D = 0; E = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Control Pattern 1", test_num);
            A = 1; B = 0; C = 1; D = 1; E = 0;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Control Pattern 2", test_num);
            A = 0; B = 1; C = 1; D = 0; E = 1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_z0;
        input expected_z1;
        input expected_z2;
        input expected_z3;
        input expected_z4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3) &&
                expected_z4 === (expected_z4 ^ z4 ^ expected_z4)) begin
                $display("PASS");
                $display("  Outputs: z0=%b, z1=%b, z2=%b, z3=%b, z4=%b",
                         z0, z1, z2, z3, z4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%b, z1=%b, z2=%b, z3=%b, z4=%b",
                         expected_z0, expected_z1, expected_z2, expected_z3, expected_z4);
                $display("  Got:      z0=%b, z1=%b, z2=%b, z3=%b, z4=%b",
                         z0, z1, z2, z3, z4);
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
