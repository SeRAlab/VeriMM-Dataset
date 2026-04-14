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
    wire full;

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
        .empty(empty),
        .full(full)
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
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task push_item;

        input [3:0] val;
        begin
            @(negedge clk);
            data_in = val;
            push = 1;
            @(negedge clk);
            push = 0;
            data_in = 0;
        end
        endtask

    task pop_item;

        begin
            @(negedge clk);
            pop = 1;
            @(negedge clk);
            pop = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Push and Peek", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'hA;
            push = 1;
            @(negedge clk);
            push = 0;
            #2;

            #1;


            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill to Capacity", test_num);
            reset_dut();

            push_item(4'h1);
            push_item(4'h2);
            push_item(4'h3);
            push_item(4'h4);
            #2;

            #1;


            check_outputs(4'h4, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LIFO Order Check", test_num);
            reset_dut();
            push_item(4'h5);
            push_item(4'h9);
            @(negedge clk);
            pop = 1;
            @(negedge clk);
            pop = 0;
            #2;

            #1;


            check_outputs(4'h5, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Protection", test_num);
            reset_dut();
            push_item(4'h1);
            push_item(4'h2);
            push_item(4'h3);
            push_item(4'h4);
            push_item(4'hF);
            #2;

            #1;


            check_outputs(4'h4, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow Protection", test_num);
            reset_dut();
            @(negedge clk);
            pop = 1;
            @(negedge clk);
            pop = 0;
            #2;

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill and Empty Complete Sequence", test_num);
            reset_dut();
            push_item(4'hC);
            push_item(4'hD);
            push_item(4'hE);
            push_item(4'hF);

            pop_item();
            pop_item();
            pop_item();
            pop_item();
            #2;

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
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
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, empty, full);
    end

endmodule
