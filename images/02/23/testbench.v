`timescale 1ns/1ps

module LIFO_stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [3:0] data_out;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFO_stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .rst(rst),
        .data_out(data_out),
        .empty(empty)
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
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check Empty Flag after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Push and Pop", test_num);
            reset_dut();


            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: LIFO Order Check (2 elements)", test_num);
            reset_dut();


            data_in = 4'h1; push = 1; @(posedge clk);

            data_in = 4'h2; push = 1; @(posedge clk);
            push = 0; @(posedge clk);


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(4'h2, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: LIFO Sequence Exhaustion", test_num);
            reset_dut();


            data_in = 4'h1; push = 1; @(posedge clk);
            data_in = 4'h2; push = 1; @(posedge clk);
            data_in = 4'h3; push = 1; @(posedge clk);
            push = 0; @(posedge clk);


            pop = 1; @(posedge clk);

            pop = 1; @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Fill Stack to Capacity", test_num);
            reset_dut();


            push = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            push = 0;
            @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Empty Pop Check", test_num);
            reset_dut();

            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Interleaved Push and Pop", test_num);
            reset_dut();


            data_in = 4'h5; push = 1; @(posedge clk);
            push = 0; pop = 1; @(posedge clk);
            pop = 0; @(posedge clk);


            data_in = 4'hC; push = 1; @(posedge clk);
            data_in = 4'hD; push = 1; @(posedge clk);
            push = 0; pop = 1; @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(4'hD, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LIFO_stack Testbench");
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
        input [3:0] expected_data_out;
        input expected_empty;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b",
                         data_out, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b",
                         expected_data_out, expected_empty);
                $display("  Got:      data_out=%h, empty=%b",
                         data_out, empty);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, empty);
    end

endmodule
