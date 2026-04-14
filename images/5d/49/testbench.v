`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg X;
    reg Y;
    wire G;
    wire P;
    wire Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .X(X),
        .Y(Y),
        .G(G),
        .P(P),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        X = 1'b0; Y = 1'b0; Cin = 1'b0;
        $display("Testcase %0d: X=0, Y=0, Cin=0", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        X = 1'b0; Y = 1'b0; Cin = 1'b1;
        $display("Testcase %0d: X=0, Y=0, Cin=1", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        X = 1'b0; Y = 1'b1; Cin = 1'b0;
        $display("Testcase %0d: X=0, Y=1, Cin=0", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        X = 1'b0; Y = 1'b1; Cin = 1'b1;
        $display("Testcase %0d: X=0, Y=1, Cin=1", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        X = 1'b1; Y = 1'b0; Cin = 1'b0;
        $display("Testcase %0d: X=1, Y=0, Cin=0", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        X = 1'b1; Y = 1'b0; Cin = 1'b1;
        $display("Testcase %0d: X=1, Y=0, Cin=1", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        X = 1'b1; Y = 1'b1; Cin = 1'b0;
        $display("Testcase %0d: X=1, Y=1, Cin=0", test_num);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        X = 1'b1; Y = 1'b1; Cin = 1'b1;
        $display("Testcase %0d: X=1, Y=1, Cin=1", test_num);
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_G;
        input expected_P;
        input expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G) &&
                expected_P === (expected_P ^ P ^ expected_P) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: G=%b, P=%b, Sum=%b",
                         G, P, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%b, P=%b, Sum=%b",
                         expected_G, expected_P, expected_Sum);
                $display("  Got:      G=%b, P=%b, Sum=%b",
                         G, P, Sum);
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
