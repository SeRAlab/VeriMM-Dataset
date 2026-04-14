`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DIVIDEND;
    reg [7:0] DIVISOR;
    wire [7:0] QUOTIENT;
    wire [7:0] REMAINDER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .DIVIDEND(DIVIDEND),
        .DIVISOR(DIVISOR),
        .QUOTIENT(QUOTIENT),
        .REMAINDER(REMAINDER)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic Division (Even) - 20 / 4", test_num);
        DIVIDEND = 8'd20;
        DIVISOR = 8'd4;
        #1;

        check_outputs(8'd5, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Basic Division (With Remainder) - 25 / 7", test_num);
        DIVIDEND = 8'd25;
        DIVISOR = 8'd7;
        #1;

        check_outputs(8'd3, 8'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Divisor Larger Than Dividend - 5 / 12", test_num);
        DIVIDEND = 8'd5;
        DIVISOR = 8'd12;
        #1;

        check_outputs(8'd0, 8'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Divide by One - 127 / 1", test_num);
        DIVIDEND = 8'd127;
        DIVISOR = 8'd1;
        #1;

        check_outputs(8'd127, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Dividend is Zero - 0 / 15", test_num);
        DIVIDEND = 8'd0;
        DIVISOR = 8'd15;
        #1;

        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Divide by Self - 55 / 55", test_num);
        DIVIDEND = 8'd55;
        DIVISOR = 8'd55;
        #1;

        check_outputs(8'd1, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Maximum Values - 255 / 2", test_num);
        DIVIDEND = 8'd255;
        DIVISOR = 8'd2;
        #1;

        check_outputs(8'd127, 8'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Large Remainder - 200 / 11", test_num);
        DIVIDEND = 8'd200;
        DIVISOR = 8'd11;
        #1;

        check_outputs(8'd18, 8'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Division by Zero - 10 / 0", test_num);
        DIVIDEND = 8'd10;
        DIVISOR = 8'd0;


        #1;



        check_outputs(8'hFF, 8'd10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Prime Number Division - 97 / 13", test_num);
        DIVIDEND = 8'd97;
        DIVISOR = 8'd13;
        #1;

        check_outputs(8'd7, 8'd6);
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
        input [7:0] expected_QUOTIENT;
        input [7:0] expected_REMAINDER;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_QUOTIENT === (expected_QUOTIENT ^ QUOTIENT ^ expected_QUOTIENT) &&
                expected_REMAINDER === (expected_REMAINDER ^ REMAINDER ^ expected_REMAINDER)) begin
                $display("PASS");
                $display("  Outputs: QUOTIENT=%h, REMAINDER=%h",
                         QUOTIENT, REMAINDER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QUOTIENT=%h, REMAINDER=%h",
                         expected_QUOTIENT, expected_REMAINDER);
                $display("  Got:      QUOTIENT=%h, REMAINDER=%h",
                         QUOTIENT, REMAINDER);
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
