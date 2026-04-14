`timescale 1ns/1ps

module timer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] max_value;
    reg reset;
    reg start;
    reg stop;
    wire [31:0] count;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_32bit dut (
        .clk(clk),
        .max_value(max_value),
        .reset(reset),
        .start(start),
        .stop(stop),
        .count(count),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            stop = 0;
            max_value = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic counting", test_num);
            reset_dut();

            max_value = 32'd100;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(32'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stop signal test", test_num);
            reset_dut();

            max_value = 32'd100;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(5) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'd6, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow check", test_num);
            reset_dut();

            max_value = 32'd5;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'd5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap-around check", test_num);
            reset_dut();

            max_value = 32'd5;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Restart counting", test_num);
            reset_dut();

            max_value = 32'hFFFF;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(3) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat(3) @(posedge clk);

            start = 1;
            @(posedge clk);
            start = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(32'd7, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            max_value = 32'd100;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(20) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary max_value=1", test_num);
            reset_dut();

            max_value = 32'd1;
            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_32bit Testbench");
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
        input [31:0] expected_count;
        input expected_overflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, overflow=%b",
                         count, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, overflow=%b",
                         expected_count, expected_overflow);
                $display("  Got:      count=%h, overflow=%b",
                         count, overflow);
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
        $dumpvars(0,clk, max_value, reset, start, stop, count, overflow);
    end

endmodule
