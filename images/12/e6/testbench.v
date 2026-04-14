`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dividend;
    reg [4:0] divisor;
    reg rst_n;
    wire done;
    wire [4:0] quotient;
    wire [4:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst_n(rst_n),
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
            rst_n = 0;
            dividend = 0;
            divisor = 0;
            #10;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: 15 / 3", test_num);
            reset_dut();
            dividend = 5'd15;
            divisor = 5'd3;


            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd5, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 22 / 4", test_num);
            reset_dut();
            dividend = 5'd22;
            divisor = 5'd4;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd5, 5'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 0 / 10", test_num);
            reset_dut();
            dividend = 5'd0;
            divisor = 5'd10;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd0, 5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 5 / 12", test_num);
            reset_dut();
            dividend = 5'd5;
            divisor = 5'd12;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd0, 5'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 13 / 13", test_num);
            reset_dut();
            dividend = 5'd13;
            divisor = 5'd13;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd1, 5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 31 / 1", test_num);
            reset_dut();
            dividend = 5'd31;
            divisor = 5'd1;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd31, 5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 31 / 7", test_num);
            reset_dut();
            dividend = 5'd31;
            divisor = 5'd7;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd4, 5'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 31 / 16", test_num);
            reset_dut();
            dividend = 5'd31;
            divisor = 5'd16;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd1, 5'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: 1 / 2", test_num);
            reset_dut();
            dividend = 5'd1;
            divisor = 5'd2;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd0, 5'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: 31 / 31", test_num);
            reset_dut();
            dividend = 5'd31;
            divisor = 5'd31;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd1, 5'd0);
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
        input [4:0] expected_quotient;
        input [4:0] expected_remainder;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, dividend, divisor, rst_n, done, quotient, remainder);
    end

endmodule
