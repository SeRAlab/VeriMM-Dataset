`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] denominator;
    reg [7:0] numerator;
    reg start;
    wire done;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
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
            start = 0;
            numerator = 0;
            denominator = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_division_test;

        input [7:0] n;
        input [7:0] d;
        input [7:0] expected_q;
        input [7:0] expected_r;
        begin
            test_num = test_num + 1;
            numerator = n;
            denominator = d;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork : wait_or_timeout
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout;
                end
                begin
                    repeat (50) @(posedge clk);
                    $display("Timeout waiting for done signal!");
                    disable wait_or_timeout;
                end
            join

            $display("Test Case %0d: %d / %d", test_num, n, d);
            #1;

            check_outputs(1'b1, expected_q, expected_r);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();

            run_division_test(8'd20, 8'd4, 8'd5, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            run_division_test(8'd10, 8'd3, 8'd3, 8'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            run_division_test(8'd255, 8'd2, 8'd127, 8'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            run_division_test(8'd5, 8'd10, 8'd0, 8'd5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            run_division_test(8'd0, 8'd15, 8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            run_division_test(8'd100, 8'd1, 8'd100, 8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            run_division_test(8'd255, 8'd255, 8'd1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            run_division_test(8'd53, 8'd7, 8'd7, 8'd4);
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
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
        $dumpvars(0,clk, denominator, numerator, start, done, quotient, remainder);
    end

endmodule
