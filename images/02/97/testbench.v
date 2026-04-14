`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] dividend;
    reg [1:0] divisor;
    wire [1:0] quotient;
    wire remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            dividend = 2'b00; divisor = 2'b00;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            dividend = 2'b01; divisor = 2'b00;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            dividend = 2'b10; divisor = 2'b00;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            dividend = 2'b11; divisor = 2'b00;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            dividend = 2'b00; divisor = 2'b01;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            dividend = 2'b01; divisor = 2'b01;
            #1;

            check_outputs(2'b01, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            dividend = 2'b10; divisor = 2'b01;
            #1;

            check_outputs(2'b10, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            dividend = 2'b11; divisor = 2'b01;
            #1;

            check_outputs(2'b11, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            dividend = 2'b00; divisor = 2'b10;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            dividend = 2'b01; divisor = 2'b10;
            #1;

            check_outputs(2'b00, 1'b1, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            dividend = 2'b10; divisor = 2'b10;
            #1;

            check_outputs(2'b01, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            dividend = 2'b11; divisor = 2'b10;
            #1;

            check_outputs(2'b01, 1'b1, 1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            dividend = 2'b00; divisor = 2'b11;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            dividend = 2'b01; divisor = 2'b11;
            #1;

            check_outputs(2'b00, 1'b1, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            dividend = 2'b10; divisor = 2'b11;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            dividend = 2'b11; divisor = 2'b11;
            #1;

            check_outputs(2'b01, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_2bit Testbench");
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
        input expected_remainder;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%b, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%b, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%b, valid=%b",
                         quotient, remainder, valid);
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
