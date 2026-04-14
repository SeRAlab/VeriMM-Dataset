`timescale 1ns/1ps

module floating_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floating_point_adder dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1.0 + 1.0 = 2.0", test_num);
            A = 32'h3F800000;
            B = 32'h3F800000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2.5 + 1.25 = 3.75", test_num);
            A = 32'h40200000;
            B = 32'h3FA00000;
            #1;

            check_outputs(32'h40700000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5.0 + (-2.0) = 3.0", test_num);
            A = 32'h40A00000;
            B = 32'hC0000000;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1.0 + 0.0 = 1.0", test_num);
            A = 32'h3F800000;
            B = 32'h00000000;
            #1;

            check_outputs(32'h3F800000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0.75 + 0.75 = 1.5 (Normalization Check)", test_num);
            A = 32'h3F400000;
            B = 32'h3F400000;
            #1;

            check_outputs(32'h3FC00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -10.0 + (-5.0) = -15.0", test_num);
            A = 32'hC1200000;
            B = 32'hC0A00000;
            #1;

            check_outputs(32'hC1700000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1.0 + (-1.0) = 0.0", test_num);
            A = 32'h3F800000;
            B = 32'hBF800000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1.5 + (-2.5) = -1.0", test_num);
            A = 32'h3FC00000;
            B = 32'hC0200000;
            #1;

            check_outputs(32'hBF800000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with alignment (1.0 + 0.0625)", test_num);
            A = 32'h3F800000;
            B = 32'h3D800000;
            #1;

            check_outputs(32'h3F880000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cancellation to small value (1.0 + (-0.9375))", test_num);
            A = 32'h3F800000;
            B = 32'hBF700000;
            #1;

            check_outputs(32'h3D800000);
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
        input [31:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
