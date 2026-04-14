`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire OVERFLOW;
    wire [31:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .OVERFLOW(OVERFLOW),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'h00000005;
            B = 32'h0000000A;
            $display("Test %0d: Basic Positive Addition (5 + 10)", test_num);
            #1;

            check_outputs(1'b0, 32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'h00000000;
            B = 32'h00000000;
            $display("Test %0d: Zero Addition", test_num);
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            $display("Test %0d: Positive Signed Overflow (MaxPos + 1)", test_num);

            #1;


            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'h80000000;
            B = 32'hFFFFFFFF;
            $display("Test %0d: Negative Signed Overflow (MinNeg + -1)", test_num);

            #1;


            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            $display("Test %0d: Positive and Negative Addition (-1 + 1)", test_num);
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'hFFFFFFFE;
            B = 32'hFFFFFFFF;
            $display("Test %0d: Two Negative Numbers (-2 + -1)", test_num);

            #1;


            check_outputs(1'b0, 32'hFFFFFFFD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'h40000000;
            B = 32'h40000000;
            $display("Test %0d: Large Positive Addition causing Overflow", test_num);

            #1;


            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'hC0000000;
            B = 32'hC0000000;
            $display("Test %0d: Large Negative Addition without Overflow", test_num);

            #1;


            check_outputs(1'b0, 32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'h80000000;
            B = 32'h80000000;
            $display("Test %0d: Min Negative + Min Negative Overflow", test_num);

            #1;


            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'h12345678;
            B = 32'hEDCBA988;
            $display("Test %0d: Random Positive and Negative Addition", test_num);
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
        input expected_OVERFLOW;
        input [31:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVERFLOW === (expected_OVERFLOW ^ OVERFLOW ^ expected_OVERFLOW) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: OVERFLOW=%b, SUM=%h",
                         OVERFLOW, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVERFLOW=%b, SUM=%h",
                         expected_OVERFLOW, expected_SUM);
                $display("  Got:      OVERFLOW=%b, SUM=%h",
                         OVERFLOW, SUM);
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
