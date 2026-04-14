`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop;
    reg [7:0] push_data;
    reg reset;
    wire empty;
    wire [7:0] top_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pop(pop),
        .push_data(push_data),
        .reset(reset),
        .empty(empty),
        .top_data(top_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pop = 0;
            push_data = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Push and Pop", test_num);
            reset_dut();

            push_data = 8'hA5;
            @(posedge clk);
            #1 push_data = 8'h00;

            pop = 1;
            @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LIFO Order Logic (3 items)", test_num);
            reset_dut();

            push_data = 8'h11; @(posedge clk);
            #1 push_data = 8'h22; @(posedge clk);
            #1 push_data = 8'h33; @(posedge clk);
            #1 push_data = 8'h00;

            pop = 1; @(posedge clk);
            #1 pop = 1; @(posedge clk);
            #1 pop = 1; @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(1'b1, 8'h11);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Depth (8 items) and Clear", test_num);
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                push_data = i[7:0];
                @(posedge clk);
            end
            #1 push_data = 8'h00;

            pop = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1 pop = 0;

            #1;


            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partial Pop and Empty Flag check", test_num);
            reset_dut();

            push_data = 8'hAA; @(posedge clk);
            #1 push_data = 8'hBB; @(posedge clk);
            #1 push_data = 8'h00;
            pop = 1; @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(1'b0, 8'hBB);
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
        input [7:0] expected_top_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_top_data === (expected_top_data ^ top_data ^ expected_top_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, top_data=%h",
                         empty, top_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, top_data=%h",
                         expected_empty, expected_top_data);
                $display("  Got:      empty=%b, top_data=%h",
                         empty, top_data);
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
        $dumpvars(0,clk, pop, push_data, reset, empty, top_data);
    end

endmodule
