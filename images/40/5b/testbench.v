`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] x;
    wire [15:0] next_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .next_x(next_x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: At the local minimum (f'(x)=0)");
            a = 16'sd1;
            b = 16'sd-10;
            c = 16'sd25;
            x = 16'sd5;

            #1;


            check_outputs(16'sd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Positive gradient (descending left)");
            a = 16'sd1;
            b = 16'sd0;
            c = 16'sd0;
            x = 16'sd10;

            #1;


            check_outputs(16'sd-10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Negative gradient (descending right)");
            a = 16'sd1;
            b = 16'sd0;
            c = 16'sd0;
            x = 16'sd-5;

            #1;


            check_outputs(16'sd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Linear function (a=0)");
            a = 16'sd0;
            b = 16'sd4;
            c = 16'sd10;
            x = 16'sd20;

            #1;


            check_outputs(16'sd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Constant function (a=0, b=0)");
            a = 16'sd0;
            b = 16'sd0;
            c = 16'sd100;
            x = 16'sd50;

            #1;


            check_outputs(16'sd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Concave down function (negative a)");
            a = 16'sd-2;
            b = 16'sd0;
            c = 16'sd8;
            x = 16'sd2;

            #1;


            check_outputs(16'sd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_next_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_x === (expected_next_x ^ next_x ^ expected_next_x)) begin
                $display("PASS");
                $display("  Outputs: next_x=%h",
                         next_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_x=%h",
                         expected_next_x);
                $display("  Got:      next_x=%h",
                         next_x);
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
