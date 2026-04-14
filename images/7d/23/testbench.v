`timescale 1ns/1ps

module binary_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_comparator dut (
        .a(a),
        .b(b),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'd0; b = 4'd0;
            $display("Testcase %0d: Testing equality at zero (a=0, b=0)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'd15; b = 4'd15;
            $display("Testcase %0d: Testing equality at max (a=15, b=15)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'b1000; b = 4'b0111;
            $display("Testcase %0d: Testing a > b via MSB (a=8, b=7)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'b0111; b = 4'b1000;
            $display("Testcase %0d: Testing a < b via MSB (a=7, b=8)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'd1; b = 4'd0;
            $display("Testcase %0d: Testing a > b via LSB (a=1, b=0)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'd14; b = 4'd15;
            $display("Testcase %0d: Testing a < b via LSB (a=14, b=15)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'd15; b = 4'd0;
            $display("Testcase %0d: Testing absolute max vs min (a=15, b=0)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'd0; b = 4'd15;
            $display("Testcase %0d: Testing absolute min vs max (a=0, b=15)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'd7; b = 4'd7;
            $display("Testcase %0d: Testing mid-range equality (a=7, b=7)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'd10; b = 4'd5;
            $display("Testcase %0d: Testing random comparison (a=10, b=5)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_comparator Testbench");
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
        input expected_eq;
        input expected_gt;
        input expected_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b, lt=%b",
                         expected_eq, expected_gt, expected_lt);
                $display("  Got:      eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
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
