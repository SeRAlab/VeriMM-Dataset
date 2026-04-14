`timescale 1ns/1ps

module merge_sort_4input_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    wire [3:0] O1;
    wire [3:0] O2;
    wire [3:0] O3;
    wire [3:0] O4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4input dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .O1(O1),
        .O2(O2),
        .O3(O3),
        .O4(O4)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Already Sorted Ascending", test_num);
        A = 4'd1; B = 4'd3; C = 4'd5; D = 4'd7;
        #1;

        check_outputs(4'd1, 4'd3, 4'd5, 4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sorted Descending", test_num);
        A = 4'd15; B = 4'd10; C = 4'd5; D = 4'd0;
        #1;

        check_outputs(4'd0, 4'd5, 4'd10, 4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Permutation 1", test_num);
        A = 4'd8; B = 4'd2; C = 4'd12; D = 4'd4;
        #1;

        check_outputs(4'd2, 4'd4, 4'd8, 4'd12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Identical", test_num);
        A = 4'd9; B = 4'd9; C = 4'd9; D = 4'd9;
        #1;

        check_outputs(4'd9, 4'd9, 4'd9, 4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Duplicates Present", test_num);
        A = 4'd3; B = 4'd11; C = 4'd3; D = 4'd1;
        #1;

        check_outputs(4'd1, 4'd3, 4'd3, 4'd11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max and Min Values", test_num);
        A = 4'd15; B = 4'd0; C = 4'd15; D = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd15, 4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Permutation 2", test_num);
        A = 4'd2; B = 4'd14; C = 4'd6; D = 4'd10;
        #1;

        check_outputs(4'd2, 4'd6, 4'd10, 4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range Cluster", test_num);
        A = 4'd7; B = 4'd8; C = 4'd6; D = 4'd7;
        #1;

        check_outputs(4'd6, 4'd7, 4'd7, 4'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4input Testbench");
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
        input [3:0] expected_O1;
        input [3:0] expected_O2;
        input [3:0] expected_O3;
        input [3:0] expected_O4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3) &&
                expected_O4 === (expected_O4 ^ O4 ^ expected_O4)) begin
                $display("PASS");
                $display("  Outputs: O1=%h, O2=%h, O3=%h, O4=%h",
                         O1, O2, O3, O4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O1=%h, O2=%h, O3=%h, O4=%h",
                         expected_O1, expected_O2, expected_O3, expected_O4);
                $display("  Got:      O1=%h, O2=%h, O3=%h, O4=%h",
                         O1, O2, O3, O4);
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
