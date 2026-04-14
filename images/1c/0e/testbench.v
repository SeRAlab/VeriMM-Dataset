`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg enable;
    reg reset;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .clock(clock),
        .dividend(dividend),
        .divisor(divisor),
        .enable(enable),
        .reset(reset),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            enable = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clock);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd8;
            divisor = 4'd2;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (8 / 2): ", test_num);
            #1;

            check_outputs(4'd4, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd7;
            divisor = 4'd3;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (7 / 3): ", test_num);
            #1;

            check_outputs(4'd2, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd3;
            divisor = 4'd5;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (3 / 5): ", test_num);
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd15;
            divisor = 4'd4;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (15 / 4): ", test_num);
            #1;

            check_outputs(4'd3, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd9;
            divisor = 4'd9;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (9 / 9): ", test_num);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd12;
            divisor = 4'd1;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (12 / 1): ", test_num);
            #1;

            check_outputs(4'd12, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            dividend = 4'd0;
            divisor = 4'd6;
            enable = 1;
            @(posedge clock);
            #1;
            $write("Test Case %0d (0 / 6): ", test_num);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();

            dividend = 4'd10;
            divisor = 4'd2;
            enable = 1;
            @(posedge clock);
            #1;


            dividend = 4'd4;
            divisor = 4'd1;
            enable = 0;
            @(posedge clock);
            #1;
            $write("Test Case %0d (Enable low check): ", test_num);

            #1;


            check_outputs(4'd5, 4'd0);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, dividend, divisor, enable, reset, quotient, remainder);
    end

endmodule
