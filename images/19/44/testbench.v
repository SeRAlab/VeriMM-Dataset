`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [3:0] divisor;
    reg reset;
    wire done;
    wire [7:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .done(done),
        .quotient(quotient)
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
            $display("Test Case %0d: 20 / 5", test_num);
            dividend = 8'd20;
            divisor = 4'd5;


            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd4);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 22 / 7", test_num);
            dividend = 8'd22;
            divisor = 4'd7;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 0 / 10", test_num);
            dividend = 8'd0;
            divisor = 4'd10;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 255 / 15", test_num);
            dividend = 8'd255;
            divisor = 4'd15;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd17);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 3 / 8", test_num);
            dividend = 8'd3;
            divisor = 4'd8;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 12 / 12", test_num);
            dividend = 8'd12;
            divisor = 4'd12;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 123 / 1", test_num);
            dividend = 8'd123;
            divisor = 4'd1;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd123);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 200 / 2", test_num);
            dividend = 8'd200;
            divisor = 4'd2;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd100);
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
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h",
                         done, quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h",
                         expected_done, expected_quotient);
                $display("  Got:      done=%b, quotient=%h",
                         done, quotient);
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
        $dumpvars(0,clk, dividend, divisor, reset, done, quotient);
    end

endmodule
