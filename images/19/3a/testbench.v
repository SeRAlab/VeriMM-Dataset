`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] dividend;
    reg [1:0] divisor;
    wire [1:0] quotient;
    wire [1:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
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
            dividend = 2'b0;
            divisor = 2'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0 / 1", test_num);
            dividend = 2'd0;
            divisor = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 1 / 1", test_num);
            dividend = 2'd1;
            divisor = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 2 / 1", test_num);
            dividend = 2'd2;
            divisor = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 2'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 3 / 1", test_num);
            dividend = 2'd3;
            divisor = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3, 2'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 2 / 2", test_num);
            dividend = 2'd2;
            divisor = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 3 / 2", test_num);
            dividend = 2'd3;
            divisor = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 1 / 2", test_num);
            dividend = 2'd1;
            divisor = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 3 / 3", test_num);
            dividend = 2'd3;
            divisor = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 2 / 3", test_num);
            dividend = 2'd2;
            divisor = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 2'd2);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0 / 3", test_num);
            dividend = 2'd0;
            divisor = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 2'd0);
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
        $dumpvars(0,clk, dividend, divisor, quotient, remainder);
    end

endmodule
