`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] denominator;
    reg [1:0] numerator;
    wire [1:0] quotient;
    wire [1:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .denominator(denominator),
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: numerator=0, denominator=0 (Div by Zero)", test_num);
        numerator = 2'b00;
        denominator = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: numerator=1, denominator=0 (Div by Zero)", test_num);
        numerator = 2'b01;
        denominator = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: numerator=2, denominator=0 (Div by Zero)", test_num);
        numerator = 2'b10;
        denominator = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: numerator=3, denominator=0 (Div by Zero)", test_num);
        numerator = 2'b11;
        denominator = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: numerator=0, denominator=1", test_num);
        numerator = 2'b00;
        denominator = 2'b01;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: numerator=1, denominator=1", test_num);
        numerator = 2'b01;
        denominator = 2'b01;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: numerator=2, denominator=1", test_num);
        numerator = 2'b10;
        denominator = 2'b01;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: numerator=3, denominator=1", test_num);
        numerator = 2'b11;
        denominator = 2'b01;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: numerator=0, denominator=2", test_num);
        numerator = 2'b00;
        denominator = 2'b10;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: numerator=1, denominator=2", test_num);
        numerator = 2'b01;
        denominator = 2'b10;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: numerator=2, denominator=2", test_num);
        numerator = 2'b10;
        denominator = 2'b10;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: numerator=3, denominator=2", test_num);
        numerator = 2'b11;
        denominator = 2'b10;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: numerator=0, denominator=3", test_num);
        numerator = 2'b00;
        denominator = 2'b11;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: numerator=1, denominator=3", test_num);
        numerator = 2'b01;
        denominator = 2'b11;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: numerator=2, denominator=3", test_num);
        numerator = 2'b10;
        denominator = 2'b11;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: numerator=3, denominator=3", test_num);
        numerator = 2'b11;
        denominator = 2'b11;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [1:0] expected_quotient;
        input [1:0] expected_remainder;
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
