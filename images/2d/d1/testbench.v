`timescale 1ns/1ps

module xnor_5input_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xnor_5input dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs zero (0 high inputs - Even)", test_num);
            a = 0; b = 0; c = 0; d = 0; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: One input high (1 high input - Odd)", test_num);
            a = 1; b = 0; c = 0; d = 0; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Two inputs high (2 high inputs - Even)", test_num);
            a = 1; b = 1; c = 0; d = 0; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Three inputs high (3 high inputs - Odd)", test_num);
            a = 1; b = 1; c = 1; d = 0; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Four inputs high (4 high inputs - Even)", test_num);
            a = 1; b = 1; c = 1; d = 1; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Five inputs high (5 high inputs - Odd)", test_num);
            a = 1; b = 1; c = 1; d = 1; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Alternating pattern (2 high inputs - Even)", test_num);
            a = 0; b = 1; c = 0; d = 1; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Alternating pattern (3 high inputs - Odd)", test_num);
            a = 1; b = 0; c = 1; d = 0; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Single LSB high (1 high input - Odd)", test_num);
            a = 0; b = 0; c = 0; d = 0; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Four inputs high varied (4 high inputs - Even)", test_num);
            a = 0; b = 1; c = 1; d = 1; e = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xnor_5input Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
