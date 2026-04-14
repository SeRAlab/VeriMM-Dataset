`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg clk;
    reg x;
    reg y;
    reg z;
    wire B;
    wire C;
    wire D;
    wire E;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .x(x),
        .y(y),
        .z(z),
        .B(B),
        .C(C),
        .D(D),
        .E(E)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);

            A = 0; x = 0; y = 0; z = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs high", test_num);
            A = 1; x = 1; y = 1; z = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift logic check (y=1, z=0)", test_num);
            A = 0; x = 0; y = 1; z = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift logic check (y=0, z=1)", test_num);
            A = 0; x = 0; y = 0; z = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Average check (x=1, y=1, z=0)", test_num);
            A = 0; x = 1; y = 1; z = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Conditional B (A=1, logic check)", test_num);
            A = 1; x = 0; y = 0; z = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full average scaled (x=1, y=1, z=1)", test_num);
            A = 0; x = 1; y = 1; z = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle A with constant inputs", test_num);
            x = 0; y = 1; z = 1; A = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 1, 0);

            A = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 1, 0);
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
        input expected_B;
        input expected_C;
        input expected_D;
        input expected_E;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D === (expected_D ^ D ^ expected_D) &&
                expected_E === (expected_E ^ E ^ expected_E)) begin
                $display("PASS");
                $display("  Outputs: B=%b, C=%b, D=%b, E=%b",
                         B, C, D, E);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%b, C=%b, D=%b, E=%b",
                         expected_B, expected_C, expected_D, expected_E);
                $display("  Got:      B=%b, C=%b, D=%b, E=%b",
                         B, C, D, E);
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
