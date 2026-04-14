`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg start;
    wire done;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 8 / 2 (No Remainder)", test_num);
        dividend = 4'd8;
        divisor = 4'd2;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd4, 4'd0);
        start = 0;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 7 / 3", test_num);
        dividend = 4'd7;
        divisor = 4'd3;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd2, 4'd1);
        start = 0;
        #10;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 15 / 15", test_num);
        dividend = 4'd15;
        divisor = 4'd15;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd1, 4'd0);
        start = 0;
        #10;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 3 / 5 (Quotient 0)", test_num);
        dividend = 4'd3;
        divisor = 4'd5;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd0, 4'd3);
        start = 0;
        #10;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0 / 7", test_num);
        dividend = 4'd0;
        divisor = 4'd7;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd0, 4'd0);
        start = 0;
        #10;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 13 / 1", test_num);
        dividend = 4'd13;
        divisor = 4'd1;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd13, 4'd0);
        start = 0;
        #10;
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 11 / 4", test_num);
        dividend = 4'd11;
        divisor = 4'd4;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd2, 4'd3);
        start = 0;
        #10;
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 1 / 1", test_num);
        dividend = 4'd1;
        divisor = 4'd1;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd1, 4'd0);
        start = 0;
        #10;
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 13 / 3", test_num);
        dividend = 4'd13;
        divisor = 4'd3;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd4, 4'd1);
        start = 0;
        #10;
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 15 / 2", test_num);
        dividend = 4'd15;
        divisor = 4'd2;
        start = 1;
        #10;
        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 4'd7, 4'd1);
        start = 0;
        #10;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("non_restoring_divider Testbench");
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
        input expected_done;
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
