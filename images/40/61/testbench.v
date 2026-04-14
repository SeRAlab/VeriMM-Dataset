`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire a_eq_b;
    wire a_gt_b;
    wire a_lt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .a(a),
        .b(b),
        .a_eq_b(a_eq_b),
        .a_gt_b(a_gt_b),
        .a_lt_b(a_lt_b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Zero", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0000;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);



        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Max Value", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Greater Than", test_num);
            a = 32'd100;
            b = 32'd50;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Less Than", test_num);
            a = 32'd25;
            b = 32'd75;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Difference in MSB (GT)", test_num);
            a = 32'h8000_0000;
            b = 32'h7FFF_FFFF;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Difference in MSB (LT)", test_num);
            a = 32'h7FFF_FFFF;
            b = 32'h8000_0000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Difference in LSB (GT)", test_num);
            a = 32'h0000_0001;
            b = 32'h0000_0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Difference in LSB (LT)", test_num);
            a = 32'hFFFF_FFFE;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern (GT)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern (LT)", test_num);
            a = 32'h5555_5555;
            b = 32'hAAAA_AAAA;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-word difference", test_num);
            a = 32'h1234_5678;
            b = 32'h1234_4321;
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
        $display("comparator Testbench");
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
        input expected_a_eq_b;
        input expected_a_gt_b;
        input expected_a_lt_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_eq_b === (expected_a_eq_b ^ a_eq_b ^ expected_a_eq_b) &&
                expected_a_gt_b === (expected_a_gt_b ^ a_gt_b ^ expected_a_gt_b) &&
                expected_a_lt_b === (expected_a_lt_b ^ a_lt_b ^ expected_a_lt_b)) begin
                $display("PASS");
                $display("  Outputs: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         expected_a_eq_b, expected_a_gt_b, expected_a_lt_b);
                $display("  Got:      a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
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
