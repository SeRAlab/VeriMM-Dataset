`timescale 1ns/1ps

module divider_8bit_tb;

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
    divider_8bit dut (
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
            repeat(2) @(posedge clk);
        end
        endtask
    task wait_until_done;

        begin
            @(posedge clk);
            while (!done) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: 100 / 10", test_num);
            reset_dut();
            numerator = 8'd100;
            denominator = 8'd10;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 8'd10, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: 255 / 4", test_num);
            reset_dut();
            numerator = 8'd255;
            denominator = 8'd4;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 8'd63, 8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: 5 / 20", test_num);
            reset_dut();
            numerator = 8'd5;
            denominator = 8'd20;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: 42 / 1", test_num);
            reset_dut();
            numerator = 8'd42;
            denominator = 8'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 8'd42, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: 0 / 50", test_num);
            reset_dut();
            numerator = 8'd0;
            denominator = 8'd50;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: 10 / 0 (Div by Zero)", test_num);
            reset_dut();
            numerator = 8'd10;
            denominator = 8'd0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();

            #1;


            check_outputs(1'b1, 8'hFF, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: 128 / 128", test_num);
            reset_dut();
            numerator = 8'd128;
            denominator = 8'd128;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 8'd1, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_8bit Testbench");
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
