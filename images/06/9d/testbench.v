`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire overflow;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (Positive)", test_num);
            a = 32'd15;
            b = 32'd25;
            #1;

            check_outputs(1'b0, 32'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            a = 32'd0;
            b = 32'd0;
            #1;

            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Addition (No Overflow)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Sign Addition (Positive Result)", test_num);
            a = 32'd100;
            b = 32'hFFFFFFCE;
            #1;

            check_outputs(1'b0, 32'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Overflow (Max Pos + 1)", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h00000001;
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Overflow (Large Positive Sum)", test_num);
            a = 32'h40000000;
            b = 32'h40000000;
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Overflow (Min Neg + (-1))", test_num);
            a = 32'h80000000;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Overflow (Min Neg + Min Neg)", test_num);
            a = 32'h80000000;
            b = 32'h80000000;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Positive and Min Negative", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h80000000;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Unsigned Addition (No Signed Overflow)", test_num);
            a = 32'hF0000000;
            b = 32'h10000000;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_overflow;
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
