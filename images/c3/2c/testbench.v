`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] num1;
    reg [31:0] num2;
    reg sel;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .num1(num1),
        .num2(num2),
        .sel(sel),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            num1 = 32'd100;
            num2 = 32'd100;
            sel = 1'b0;
            $display("Test %0d: Unsigned Equality (100 == 100)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            num1 = 32'd250;
            num2 = 32'd150;
            sel = 1'b0;
            $display("Test %0d: Unsigned Greater Than (250 > 150)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            num1 = 32'd50;
            num2 = 32'd150;
            sel = 1'b0;
            $display("Test %0d: Unsigned Less Than (50 < 150)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            num1 = 32'h8000_0000;
            num2 = 32'h7FFF_FFFF;
            sel = 1'b0;
            $display("Test %0d: Unsigned MSB check (0x80000000 > 0x7FFFFFFF)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            num1 = 32'd42;
            num2 = 32'd42;
            sel = 1'b1;
            $display("Test %0d: Signed Positive Equality (42 == 42)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            num1 = 32'hFFFF_FFFE;
            num2 = 32'hFFFF_FFFE;
            sel = 1'b1;
            $display("Test %0d: Signed Negative Equality (-2 == -2)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            num1 = 32'd1;
            num2 = 32'hFFFF_FFFF;
            sel = 1'b1;
            $display("Test %0d: Signed Pos vs Neg (1 > -1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            num1 = 32'hFFFF_FFFF;
            num2 = 32'd1;
            sel = 1'b1;
            $display("Test %0d: Signed Neg vs Pos (-1 < 1)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            num1 = 32'hFFFF_FFF6;
            num2 = 32'hFFFF_FFEC;
            sel = 1'b1;
            $display("Test %0d: Signed Neg vs Neg (-10 > -20)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            num1 = 32'hFFFF_FFEC;
            num2 = 32'hFFFF_FFF6;
            sel = 1'b1;
            $display("Test %0d: Signed Neg vs Neg (-20 < -10)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            num1 = 32'h8000_0000;
            num2 = 32'h7FFF_FFFF;
            sel = 1'b1;
            $display("Test %0d: Signed Extreme (Min Neg < Max Pos)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            num1 = 32'hFFFF_FFFF;
            num2 = 32'h0000_0001;
            sel = 1'b0;
            $display("Test %0d: Unsigned Mode Difference (0xFFFFFFFF > 1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);

            test_num = test_num + 1;
            sel = 1'b1;
            $display("Test %0d: Signed Mode Difference (0xFFFFFFFF < 1)", test_num);
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
        testcase012();
        
        
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
