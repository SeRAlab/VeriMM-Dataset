`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dividend;
    reg rst;
    reg start;
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
        .rst(rst),
        .start(start),
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
            rst = 1;
            start = 0;
            dividend = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 0", test_num);
            dividend = 5'd0;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 3", test_num);
            dividend = 5'd3;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd1, 5'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 10", test_num);
            dividend = 5'd10;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd3, 5'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 31", test_num);
            dividend = 5'd31;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd10, 5'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 2", test_num);
            dividend = 5'd2;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd0, 5'd2);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 15", test_num);
            dividend = 5'd15;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd5, 5'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: dividend = 29", test_num);
            dividend = 5'd29;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd9, 5'd2);
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
        $dumpvars(0,clk, dividend, rst, start, done, quotient, remainder);
    end

endmodule
