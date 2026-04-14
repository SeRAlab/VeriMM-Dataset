`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire equal;
    wire greater_than;
    wire less_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .equal(equal),
        .greater_than(greater_than),
        .less_than(less_than)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'sd0; B = 4'sd0;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'sd5; B = 4'sd2;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'sd1; B = 4'sd6;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'sd2; B = -4'sd3;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = -4'sd4; B = 4'sd2;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = -4'sd1; B = -4'sd5;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = -4'sd7; B = -4'sd2;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'sd7; B = 4'sd7;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = -4'sd8; B = -4'sd8;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'sd7; B = -4'sd8;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        A = -4'sd8; B = 4'sd7;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        A = 4'sd0; B = -4'sd1;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        A = -4'sd1; B = 4'sd0;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_equal;
        input expected_greater_than;
        input expected_less_than;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_less_than === (expected_less_than ^ less_than ^ expected_less_than)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater_than=%b, less_than=%b",
                         equal, greater_than, less_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater_than=%b, less_than=%b",
                         expected_equal, expected_greater_than, expected_less_than);
                $display("  Got:      equal=%b, greater_than=%b, less_than=%b",
                         equal, greater_than, less_than);
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
