`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] denominator;
    reg [9:0] numerator;
    reg rst;
    wire done;
    wire [9:0] quotient;
    wire [9:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
        .rst(rst),
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
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 20 / 4", test_num);
            numerator = 10'd20;
            denominator = 10'd4;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd5, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 25 / 7", test_num);
            numerator = 10'd25;
            denominator = 10'd7;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd3, 10'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 0 / 10", test_num);
            numerator = 10'd0;
            denominator = 10'd10;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd0, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 1023 / 1", test_num);
            numerator = 10'd1023;
            denominator = 10'd1;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd1023, 10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 5 / 12", test_num);
            numerator = 10'd5;
            denominator = 10'd12;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd0, 10'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 1023 / 1023", test_num);
            numerator = 10'd1023;
            denominator = 10'd1023;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd1, 10'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: 1023 / 2", test_num);
            numerator = 10'd1023;
            denominator = 10'd2;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd511, 10'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: 999 / 10", test_num);
            numerator = 10'd999;
            denominator = 10'd10;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd99, 10'd9);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: 512 / 8", test_num);
            numerator = 10'd512;
            denominator = 10'd8;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd64, 10'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: 1 / 2", test_num);
            numerator = 10'd1;
            denominator = 10'd2;
            reset_dut();
            wait(done);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 10'd0, 10'd1);
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
        input [9:0] expected_quotient;
        input [9:0] expected_remainder;
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
        $dumpvars(0,clk, denominator, numerator, rst, done, quotient, remainder);
    end

endmodule
