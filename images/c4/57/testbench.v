`timescale 1ns/1ps

module modulo_operator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [3:0] divisor;
    wire [3:0] remainder;

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
        test_num = test_num + 1;
        $display("Test %0d: 5 mod 2", test_num);
        dividend = 16'sd5;
        divisor = 4'sd2;
        #1;

        check_outputs(4'sd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 12 mod 4", test_num);
        dividend = 16'sd12;
        divisor = 4'sd4;
        #1;

        check_outputs(4'sd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 3 mod 7", test_num);
        dividend = 16'sd3;
        divisor = 4'sd7;
        #1;

        check_outputs(4'sd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 50 mod 0 (Zero Divisor)", test_num);
        dividend = 16'sd50;
        divisor = 4'sd0;
        #1;

        check_outputs(4'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -5 mod 3 (Negative Dividend)", test_num);
        dividend = -16'sd5;
        divisor = 4'sd3;
        #1;

        check_outputs(-4'sd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 0 mod 5", test_num);
        dividend = 16'sd0;
        divisor = 4'sd5;
        #1;

        check_outputs(4'sd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 10 mod -3", test_num);
        dividend = 16'sd10;
        divisor = -4'sd3;
        #1;

        check_outputs(4'sd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -10 mod -3", test_num);
        dividend = -16'sd10;
        divisor = -4'sd3;
        #1;

        check_outputs(-4'sd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 32767 mod 6", test_num);
        dividend = 16'sd32767;
        divisor = 4'sd6;
        #1;

        check_outputs(4'sd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -32768 mod 7", test_num);
        dividend = -16'sd32768;
        divisor = 4'sd7;
        #1;

        check_outputs(-4'sd1);
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
        input [3:0] expected_remainder;
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
