`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] dividend;
    reg [1:0] divisor;
    reg enable;
    reg reset;
    wire done;
    wire [1:0] quotient;
    wire remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .enable(enable),
        .reset(reset),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dividend = 0;
            divisor = 0;
            enable = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 3 / 1", test_num);
            dividend = 2'b11;
            divisor = 2'b01;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;


            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b11, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 3 / 2", test_num);
            dividend = 2'b11;
            divisor = 2'b10;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 3 / 3", test_num);
            dividend = 2'b11;
            divisor = 2'b11;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b01, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 2 / 1", test_num);
            dividend = 2'b10;
            divisor = 2'b01;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b10, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 2 / 2", test_num);
            dividend = 2'b10;
            divisor = 2'b10;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b01, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 1 / 1", test_num);
            dividend = 2'b01;
            divisor = 2'b01;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b01, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 1 / 2", test_num);
            dividend = 2'b01;
            divisor = 2'b10;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 0 / 3", test_num);
            dividend = 2'b00;
            divisor = 2'b11;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 2'b00, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 2 / 3", test_num);
            dividend = 2'b10;
            divisor = 2'b11;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 2'b00, 1'b0);
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
        input [1:0] expected_quotient;
        input expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%b",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%b",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%b",
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, dividend, divisor, enable, reset, done, quotient, remainder);
    end

endmodule
