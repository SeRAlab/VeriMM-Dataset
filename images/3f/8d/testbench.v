`timescale 1ns/1ps

module srt_divider_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg start;
    wire [15:0] quotient;
    wire [15:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    srt_divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple division 25 / 5", test_num);

            rst_n = 0; start = 0; dividend = 0; divisor = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);

            dividend = 16'd25;
            divisor = 16'd5;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid);
            #1;

            check_outputs(16'd5, 16'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division with remainder 100 / 7", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd100;
            divisor = 16'd7;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd14, 16'd2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend is zero 0 / 50", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd0;
            divisor = 16'd50;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd0, 16'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend less than divisor 10 / 20", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd10;
            divisor = 16'd20;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd0, 16'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large dividend 65535 / 2", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'hFFFF;
            divisor = 16'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd32767, 16'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by one 1234 / 1", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd1234;
            divisor = 16'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd1234, 16'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by same value 555 / 555", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd555;
            divisor = 16'd555;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd1, 16'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max dividend and max divisor", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'hFFFF;
            divisor = 16'hFFFF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd1, 16'd0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime-like numbers 12345 / 678", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd12345;
            divisor = 16'd678;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd18, 16'd141, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of two 1024 / 32", test_num);
            rst_n = 0; start = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            dividend = 16'd1024;
            divisor = 16'd32;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(valid);
            #1;

            check_outputs(16'd32, 16'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("srt_divider Testbench");
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
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%h, valid=%b",
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
