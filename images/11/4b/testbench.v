`timescale 1ns/1ps

module SRT_Divider_tb;

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
    SRT_Divider dut (
        .denominator(denominator),
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 0 / 5", test_num);
        numerator = 4'd0;
        denominator = 4'd5;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 7 / 1", test_num);
        numerator = 4'd7;
        denominator = 4'd1;
        #1;

        check_outputs(4'd7, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 10 / 2", test_num);
        numerator = 4'd10;
        denominator = 4'd2;
        #1;

        check_outputs(4'd5, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 15 / 15", test_num);
        numerator = 4'd15;
        denominator = 4'd15;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 15 / 1", test_num);
        numerator = 4'd15;
        denominator = 4'd1;
        #1;

        check_outputs(4'd15, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 10 / 3", test_num);
        numerator = 4'd10;
        denominator = 4'd3;
        #1;

        check_outputs(4'd3, 4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 13 / 4", test_num);
        numerator = 4'd13;
        denominator = 4'd4;
        #1;

        check_outputs(4'd3, 4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 7 / 2", test_num);
        numerator = 4'd7;
        denominator = 4'd2;
        #1;

        check_outputs(4'd3, 4'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 15 / 4", test_num);
        numerator = 4'd15;
        denominator = 4'd4;
        #1;

        check_outputs(4'd3, 4'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 2 / 5", test_num);
        numerator = 4'd2;
        denominator = 4'd5;
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 1 / 15", test_num);
        numerator = 4'd1;
        denominator = 4'd15;
        #1;

        check_outputs(4'd0, 4'd1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 11 / 3", test_num);
        numerator = 4'd11;
        denominator = 4'd3;
        #1;

        check_outputs(4'd3, 4'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRT_Divider Testbench");
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
        testcase011();
        testcase012();
        
        
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
