`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg clk;
    reg [3:0] d;
    reg rst;
    wire done;
    wire [3:0] sorted_a;
    wire [3:0] sorted_b;
    wire [3:0] sorted_c;
    wire [3:0] sorted_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .rst(rst),
        .done(done),
        .sorted_a(sorted_a),
        .sorted_b(sorted_b),
        .sorted_c(sorted_c),
        .sorted_d(sorted_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            c = 0;
            d = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Already Sorted Input (1, 2, 3, 4)", test_num);
            reset_dut();
            a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;

            while (!done) @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 4'd2, 4'd3, 4'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reverse Sorted Input (15, 10, 5, 0)", test_num);
            reset_dut();
            a = 4'd15; b = 4'd10; c = 4'd5; d = 4'd0;
            while (!done) @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd5, 4'd10, 4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Identical Elements (7, 7, 7, 7)", test_num);
            reset_dut();
            a = 4'd7; b = 4'd7; c = 4'd7; d = 4'd7;
            while (!done) @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd7, 4'd7, 4'd7, 4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Duplicates (3, 8, 3, 1)", test_num);
            reset_dut();
            a = 4'd3; b = 4'd8; c = 4'd3; d = 4'd1;
            while (!done) @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 4'd3, 4'd3, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Mixed Values (0, 15, 1, 14)", test_num);
            reset_dut();
            a = 4'd0; b = 4'd15; c = 4'd1; d = 4'd14;
            while (!done) @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd1, 4'd14, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating (12, 2, 11, 3)", test_num);
            reset_dut();
            a = 4'd12; b = 4'd2; c = 4'd11; d = 4'd3;
            while (!done) @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd2, 4'd3, 4'd11, 4'd12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_sorted_a;
        input [3:0] expected_sorted_b;
        input [3:0] expected_sorted_c;
        input [3:0] expected_sorted_d;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sorted_a === (expected_sorted_a ^ sorted_a ^ expected_sorted_a) &&
                expected_sorted_b === (expected_sorted_b ^ sorted_b ^ expected_sorted_b) &&
                expected_sorted_c === (expected_sorted_c ^ sorted_c ^ expected_sorted_c) &&
                expected_sorted_d === (expected_sorted_d ^ sorted_d ^ expected_sorted_d)) begin
                $display("PASS");
                $display("  Outputs: done=%b, sorted_a=%h, sorted_b=%h, sorted_c=%h, sorted_d=%h",
                         done, sorted_a, sorted_b, sorted_c, sorted_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, sorted_a=%h, sorted_b=%h, sorted_c=%h, sorted_d=%h",
                         expected_done, expected_sorted_a, expected_sorted_b, expected_sorted_c, expected_sorted_d);
                $display("  Got:      done=%b, sorted_a=%h, sorted_b=%h, sorted_c=%h, sorted_d=%h",
                         done, sorted_a, sorted_b, sorted_c, sorted_d);
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
        $dumpvars(0,a, b, c, clk, d, rst, done, sorted_a, sorted_b, sorted_c, sorted_d);
    end

endmodule
