`timescale 1ns/1ps

module floating_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floating_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h3f800000;
            b = 32'h3f800000;
            $display("Testcase %0d: 1.0 + 1.0", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h3fc00000;
            b = 32'h40200000;
            $display("Testcase %0d: 1.5 + 2.5", test_num);
            #1;

            check_outputs(32'h40800000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h3f800000;
            b = 32'hbf800000;
            $display("Testcase %0d: 1.0 + (-1.0)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h00000000;
            b = 32'h00000000;
            $display("Testcase %0d: 0.0 + 0.0", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h7f800000;
            b = 32'h3f800000;
            $display("Testcase %0d: Inf + 1.0", test_num);
            #1;

            check_outputs(32'h7f800000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h7fc00000;
            b = 32'h3f800000;
            $display("Testcase %0d: NaN + 1.0", test_num);
            #1;

            check_outputs(32'h7fc00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h7f800000;
            b = 32'hff800000;
            $display("Testcase %0d: Inf + (-Inf)", test_num);
            #1;

            check_outputs(32'h7fc00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h42c80000;
            b = 32'h3f000000;
            $display("Testcase %0d: 100.0 + 0.5", test_num);
            #1;

            check_outputs(32'h42c90000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'hc0a00000;
            b = 32'hc0000000;
            $display("Testcase %0d: -5.0 + -2.0", test_num);
            #1;

            check_outputs(32'hc0e00000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'h3f800001;
            b = 32'hbf800000;
            $display("Testcase %0d: Small difference subtraction", test_num);
            #1;

            check_outputs(32'h34000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floating_point_adder Testbench");
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
        input [31:0] expected_sum;
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
