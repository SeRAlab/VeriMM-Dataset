`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] denominator;
    reg [3:0] numerator;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .denominator(denominator),
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = 1;
            numerator = 4'd8;
            denominator = 4'd2;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd4, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            numerator = 4'd7;
            denominator = 4'd3;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd2, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            numerator = 4'd15;
            denominator = 4'd4;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd3, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            numerator = 4'd5;
            denominator = 4'd1;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd5, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            numerator = 4'd0;
            denominator = 4'd9;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            numerator = 4'd10;
            denominator = 4'd10;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            numerator = 4'd3;
            denominator = 4'd8;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            numerator = 4'd15;
            denominator = 4'd15;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            numerator = 4'd14;
            denominator = 4'd3;
            $display("Test %0d: %d / %d", test_num, numerator, denominator);
            #1;

            check_outputs(4'd4, 4'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            numerator = 4'd12;
            denominator = 4'd0;
            $display("Test %0d: %d / %d (Division by Zero)", test_num, numerator, denominator);

            #1;


            check_outputs(4'hf, 4'hf);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_4bit Testbench");
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
