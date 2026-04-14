`timescale 1ns/1ps

module comparator_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire A_eq_B;
    wire A_gt_B;
    wire A_lt_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_32bit dut (
        .A(A),
        .B(B),
        .A_eq_B(A_eq_B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs zero (Equality)", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs maximum (Equality)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A greater than B (Small values)", test_num);
            A = 32'd100;
            B = 32'd50;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A less than B (Small values)", test_num);
            A = 32'd50;
            B = 32'd100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A greater than B (MSB bit difference)", test_num);
            A = 32'h80000000;
            B = 32'h7FFFFFFF;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A less than B (MSB bit difference)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h80000000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A greater than B (LSB bit difference)", test_num);
            A = 32'h00000001;
            B = 32'h00000000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A less than B (LSB bit difference)", test_num);
            A = 32'h00000000;
            B = 32'h00000001;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values equality check", test_num);
            A = 32'hA5A5A5A5;
            B = 32'hA5A5A5A5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern comparison", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_32bit Testbench");
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
        input expected_A_eq_B;
        input expected_A_gt_B;
        input expected_A_lt_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_eq_B === (expected_A_eq_B ^ A_eq_B ^ expected_A_eq_B) &&
                expected_A_gt_B === (expected_A_gt_B ^ A_gt_B ^ expected_A_gt_B) &&
                expected_A_lt_B === (expected_A_lt_B ^ A_lt_B ^ expected_A_lt_B)) begin
                $display("PASS");
                $display("  Outputs: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         expected_A_eq_B, expected_A_gt_B, expected_A_lt_B);
                $display("  Got:      A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
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
