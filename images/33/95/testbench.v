`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire empty;
    wire full;
    wire [7:0] top;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFO_Stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .rst(rst),
        .empty(empty),
        .full(full),
        .top(top)
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
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 8'hA5;
            push = 1;
            @(posedge clk);
            #1;
            push = 0;

            #1;


            check_outputs(1'b0, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            data_in = 8'h11; push = 1;
            @(posedge clk); #1;


            data_in = 8'h22; push = 1;
            @(posedge clk); #1;
            push = 0;


            pop = 1;
            @(posedge clk); #1;
            pop = 0;


            #1;



            check_outputs(1'b0, 1'b0, 8'h11);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                push = 1;
                @(posedge clk); #1;
            end
            push = 0;

            #1;


            check_outputs(1'b0, 1'b1, 8'h08);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for (i = 1; i <= 4; i = i + 1) begin
                data_in = i; push = 1;
                @(posedge clk); #1;
            end
            push = 0;

            for (i = 1; i <= 4; i = i + 1) begin
                pop = 1;
                @(posedge clk); #1;
            end
            pop = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            pop = 1;
            @(posedge clk); #1;
            pop = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i; push = 1;
                @(posedge clk); #1;
            end

            data_in = 8'hFF;
            push = 1;
            @(posedge clk); #1;
            push = 0;

            #1;


            check_outputs(1'b0, 1'b1, 8'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LIFO_Stack Testbench");
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_top;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_top === (expected_top ^ top ^ expected_top)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, top=%h",
                         empty, full, top);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, top=%h",
                         expected_empty, expected_full, expected_top);
                $display("  Got:      empty=%b, full=%b, top=%h",
                         empty, full, top);
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
        $dumpvars(0,clk, data_in, pop, push, rst, empty, full, top);
    end

endmodule
