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
            $display("Testcase %0d: 1.0 + 1.0", test_num);
            a = 32'h3F800000;
            b = 32'h3F800000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 2.5 + 0.5", test_num);
            a = 32'h40200000;
            b = 32'h3F000000;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 1.0 + (-1.0)", test_num);
            a = 32'h3F800000;
            b = 32'hBF800000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 0.0 + 5.75", test_num);
            a = 32'h00000000;
            b = 32'h40B80000;
            #1;

            check_outputs(32'h40B80000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 1.5 + 1.5 (Normalization)", test_num);
            a = 32'h3FC00000;
            b = 32'h3FC00000;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 5.0 + (-2.0)", test_num);
            a = 32'h40A00000;
            b = 32'hC0000000;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: -10.0 + -5.0", test_num);
            a = 32'hC1200000;
            b = 32'hC0A00000;
            #1;

            check_outputs(32'hC1700000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 1024.0 + 0.25", test_num);
            a = 32'h44800000;
            b = 32'h3E800000;
            #1;

            check_outputs(32'h44800800);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: 1.0 + (-4.0)", test_num);
            a = 32'h3F800000;
            b = 32'hC0800000;
            #1;

            check_outputs(32'hC0400000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: 2^-14 + 2^-14", test_num);
            a = 32'h38800000;
            b = 32'h38800000;
            #1;

            check_outputs(32'h39000000);
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
