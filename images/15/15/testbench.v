`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dividend;
    reg [1:0] divisor;
    reg rst;
    wire [4:0] quotient;
    wire [4:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst(rst),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd20;
            divisor = 2'd2;
            $display("Test %0d: Division 20 / 2", test_num);

            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'd10, 5'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd31;
            divisor = 2'd3;
            $display("Test %0d: Division 31 / 3", test_num);
            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'd10, 5'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd15;
            divisor = 2'd0;
            $display("Test %0d: Division by Zero (15 / 0)", test_num);
            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'b11111, 5'b11111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd2;
            divisor = 2'd3;
            $display("Test %0d: Dividend < Divisor (2 / 3)", test_num);
            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'd0, 5'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd0;
            divisor = 2'd2;
            $display("Test %0d: Zero Dividend (0 / 2)", test_num);
            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'd0, 5'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd25;
            divisor = 2'd1;
            $display("Test %0d: Division by One (25 / 1)", test_num);
            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'd25, 5'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 5'd7;
            divisor = 2'd3;
            $display("Test %0d: Division 7 / 3", test_num);
            wait(valid == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(5'd2, 5'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("restoring_divider Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_quotient;
        input [4:0] expected_remainder;
        input expected_valid;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, dividend, divisor, rst, quotient, remainder, valid);
    end

endmodule
