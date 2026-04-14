`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire [2:0] depth;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .rst(rst),
        .data_out(data_out),
        .depth(depth)
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
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Push 2 elements, Pop 1 element");
            reset_dut();

            push = 1; data_in = 8'h11; @(posedge clk);

            push = 1; data_in = 8'h22; @(posedge clk);

            push = 0; pop = 1; @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(8'h11, 3'd1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Push 5 elements consecutively");
            reset_dut();
            push = 1; data_in = 8'h01; @(posedge clk);
            push = 1; data_in = 8'h02; @(posedge clk);
            push = 1; data_in = 8'h03; @(posedge clk);
            push = 1; data_in = 8'h04; @(posedge clk);
            push = 1; data_in = 8'h05; @(posedge clk);
            push = 0;
            #1;

            #1;


            check_outputs(8'h05, 3'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify LIFO (Last-In First-Out) behavior");
            reset_dut();

            push = 1; data_in = 8'hAA; @(posedge clk);
            push = 1; data_in = 8'hBB; @(posedge clk);
            push = 1; data_in = 8'hCC; @(posedge clk);

            push = 0; pop = 1; @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(8'hAA, 3'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Push 7 elements to check depth");
            reset_dut();
            push = 1; data_in = 8'h10; @(posedge clk);
            push = 1; data_in = 8'h20; @(posedge clk);
            push = 1; data_in = 8'h30; @(posedge clk);
            push = 1; data_in = 8'h40; @(posedge clk);
            push = 1; data_in = 8'h50; @(posedge clk);
            push = 1; data_in = 8'h60; @(posedge clk);
            push = 1; data_in = 8'h70; @(posedge clk);
            push = 0;
            #1;

            #1;


            check_outputs(8'h70, 3'd7);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Push 3 then Pop 3 to empty the stack");
            reset_dut();
            push = 1; data_in = 8'hDE; @(posedge clk);
            push = 1; data_in = 8'hAD; @(posedge clk);
            push = 1; data_in = 8'hBE; @(posedge clk);
            push = 0; pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;
            #1;

            #1;


            check_outputs(data_out, 3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stack Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_data_out;
        input [2:0] expected_depth;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_depth === (expected_depth ^ depth ^ expected_depth)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, depth=%h",
                         data_out, depth);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, depth=%h",
                         expected_data_out, expected_depth);
                $display("  Got:      data_out=%h, depth=%h",
                         data_out, depth);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, depth);
    end

endmodule
