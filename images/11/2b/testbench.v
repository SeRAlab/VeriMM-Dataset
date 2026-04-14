`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Addition (1.0 + 1.0)", test_num);
            a = 16'h0100;
            b = 16'h0100;
            #1;

            check_outputs(16'h0200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fractional Addition (0.5 + 0.25)", test_num);
            a = 16'h0080;
            b = 16'h0040;
            #1;

            check_outputs(16'h00C0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry from fraction to integer (0.75 + 0.5)", test_num);
            a = 16'h00C0;
            b = 16'h0080;
            #1;

            check_outputs(16'h0140);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive and Negative (2.0 + -1.0)", test_num);
            a = 16'h0200;
            b = 16'hFF00;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest possible increment (0.0039 + 0.0039)", test_num);
            a = 16'h0001;
            b = 16'h0001;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Addition (-2.5 + -1.25)", test_num);
            a = 16'hFD80;
            b = 16'hFEC0;
            #1;

            check_outputs(16'hFC40);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Zero", test_num);
            a = 16'h1234;
            b = 16'h0000;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive and Negative (-128.0 + 127.996)", test_num);
            a = 16'h8000;
            b = 16'h7FFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cancellation to Zero (-5.75 + 5.75)", test_num);
            a = 16'hFA40;
            b = 16'h05C0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Wrap-around (127.0 + 2.0)", test_num);
            a = 16'h7F00;
            b = 16'h0200;

            #1;


            check_outputs(16'h8100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_adder Testbench");
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
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
