`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg pop;
    reg push;
    reg rst;
    wire almost_empty;
    wire almost_full;
    wire [3:0] count;
    wire empty;
    wire full;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .pop(pop),
        .push(push),
        .rst(rst),
        .almost_empty(almost_empty),
        .almost_full(almost_full),
        .count(count),
        .empty(empty),
        .full(full),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push = 0;
            pop = 0;
            d = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task push_data;

        input [7:0] data;
        begin
            push = 1;
            d = data;
            @(posedge clk);
            #1;
            push = 0;
            d = 0;
        end
        endtask

    task pop_data;

        begin
            pop = 1;
            @(posedge clk);
            #1;
            pop = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1, 0, 4'h0, 1, 0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Push", test_num);
            reset_dut();
            push_data(8'hA5);

            #1;


            check_outputs(1, 0, 4'h1, 0, 0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single Push then Pop", test_num);
            reset_dut();
            push_data(8'h5A);
            pop_data();

            #1;


            check_outputs(1, 0, 4'h0, 1, 0, 8'h5A);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill to Full (8 elements)", test_num);
            reset_dut();
            for (i = 1; i <= 8; i = i + 1) begin
                push_data(i[7:0]);
            end

            #1;


            check_outputs(0, 1, 4'h8, 0, 1, 8'h00);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Almost Full Check", test_num);
            reset_dut();
            for (i = 1; i <= 7; i = i + 1) begin
                push_data(i[7:0]);
            end

            #1;


            check_outputs(0, 1, 4'h7, 0, 0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: FIFO Ordering", test_num);
            reset_dut();
            push_data(8'h11);
            push_data(8'h22);
            push_data(8'h33);
            pop_data();
            pop_data();

            #1;


            check_outputs(1, 0, 4'h1, 0, 0, 8'h22);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Push and Pop", test_num);
            reset_dut();
            push_data(8'hAA);


            push = 1;
            pop = 1;
            d = 8'hBB;
            @(posedge clk);
            #1;
            push = 0;
            pop = 0;


            #1;



            check_outputs(1, 0, 4'h1, 0, 0, 8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_almost_empty;
        input expected_almost_full;
        input [3:0] expected_count;
        input expected_empty;
        input expected_full;
        input [7:0] expected_q;
        begin
            if (expected_almost_empty === (expected_almost_empty ^ almost_empty ^ expected_almost_empty) &&
                expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: almost_empty=%b, almost_full=%b, count=%h, empty=%b, full=%b, q=%h",
                         almost_empty, almost_full, count, empty, full, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_empty=%b, almost_full=%b, count=%h, empty=%b, full=%b, q=%h",
                         expected_almost_empty, expected_almost_full, expected_count, expected_empty, expected_full, expected_q);
                $display("  Got:      almost_empty=%b, almost_full=%b, count=%h, empty=%b, full=%b, q=%h",
                         almost_empty, almost_full, count, empty, full, q);
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
        $dumpvars(0,clk, d, pop, push, rst, almost_empty, almost_full, count, empty, full, q);
    end

endmodule
