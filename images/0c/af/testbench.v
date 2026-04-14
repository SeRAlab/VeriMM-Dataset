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
            $display("Testcase %0d: 1.0 + 1.0 = 2.0", test_num);
            a = 32'h3f800000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 0.5 + 0.5 = 1.0", test_num);
            a = 32'h3f000000;
            b = 32'h3f000000;
            #1;

            check_outputs(32'h3f800000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 1.0 + (-1.0) = 0.0", test_num);
            a = 32'h3f800000;
            b = 32'hbf800000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 2.5 + 1.25 = 3.75", test_num);
            a = 32'h40200000;
            b = 32'h3fa00000;
            #1;

            check_outputs(32'h40700000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 128.0 + 0.5 = 128.5 (Large + Small)", test_num);
            a = 32'h43000000;
            b = 32'h3f000000;
            #1;

            check_outputs(32'h43008000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 5.0 + (-2.0) = 3.0 (Sign difference)", test_num);
            a = 32'h40a00000;
            b = 32'hc0000000;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 0.0 + 5.5 = 5.5 (Zero handling)", test_num);
            a = 32'h00000000;
            b = 32'h40b00000;
            #1;

            check_outputs(32'h40b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 1.0 + 1.1920929e-7 = 1.0000001 (Mantissa LSB)", test_num);
            a = 32'h3f800000;
            b = 32'h34000000;
            #1;

            check_outputs(32'h3f800001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: 1.125 - 1.0 = 0.125 (Normalization after subtraction)", test_num);
            a = 32'h3f900000;
            b = 32'hbf800000;
            #1;

            check_outputs(32'h3e000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: -10.0 + 4.0 = -6.0 (Negative result)", test_num);
            a = 32'hc1200000;
            b = 32'h40800000;
            #1;

            check_outputs(32'hc0c00000);
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
