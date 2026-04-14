`timescale 1ns/1ps

module modulo_operator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire [31:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    modulo_operator dut (
        .dividend(dividend),
        .divisor(divisor),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Simple division (5 %% 2)", test_num);
        dividend = 32'd5;
        divisor = 32'd2;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Dividend is multiple of divisor (100 %% 25)", test_num);
        dividend = 32'd100;
        divisor = 32'd25;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Dividend equals divisor (42 %% 42)", test_num);
        dividend = 32'd42;
        divisor = 32'd42;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Dividend < divisor (7 %% 15)", test_num);
        dividend = 32'd7;
        divisor = 32'd15;
        #1;

        check_outputs(32'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Divisor is zero (123 %% 0)", test_num);
        dividend = 32'd123;
        divisor = 32'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Dividend is zero (0 %% 99)", test_num);
        dividend = 32'd0;
        divisor = 32'd99;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Max unsigned dividend (32'hFFFFFFFF %% 10)", test_num);
        dividend = 32'hFFFFFFFF;
        divisor = 32'd10;
        #1;

        check_outputs(32'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: Large numbers (4,000,000,000 %% 3,000,000,000)", test_num);
        dividend = 32'd4000000000;
        divisor = 32'd3000000000;
        #1;

        check_outputs(32'd1000000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("modulo_operator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: remainder=%h",
                         remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: remainder=%h",
                         expected_remainder);
                $display("  Got:      remainder=%h",
                         remainder);
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
