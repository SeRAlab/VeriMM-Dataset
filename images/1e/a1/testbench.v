`timescale 1ns/1ps

module LIFO_stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop_enable;
    reg push_enable;
    reg [7:0] push_val;
    reg rst;
    wire empty;
    wire [7:0] pop_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFO_stack dut (
        .clk(clk),
        .pop_enable(pop_enable),
        .push_enable(push_enable),
        .push_val(push_val),
        .rst(rst),
        .empty(empty),
        .pop_val(pop_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push_enable = 0;
            pop_enable = 0;
            push_val = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
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


            push_val = 8'hA5;
            push_enable = 1;
            @(posedge clk);
            #1 push_enable = 0;


            pop_enable = 1;
            @(posedge clk);
            #1 pop_enable = 0;


            #1;



            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Pushes, Single Pop", test_num);
            reset_dut();


            push_val = 8'h11; push_enable = 1; @(posedge clk); #1;

            push_val = 8'h22; push_enable = 1; @(posedge clk); #1;

            push_val = 8'h33; push_enable = 1; @(posedge clk); #1;
            push_enable = 0;


            pop_enable = 1;
            @(posedge clk);
            #1 pop_enable = 0;


            #1;



            check_outputs(1'b0, 8'h33);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Stack Push and Pop Top", test_num);
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                push_val = i;
                push_enable = 1;
                @(posedge clk);
                #1;
            end
            push_enable = 0;


            pop_enable = 1;
            @(posedge clk);
            #1 pop_enable = 0;


            #1;



            check_outputs(1'b0, 8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full LIFO sequence (Push 3, Pop 3)", test_num);
            reset_dut();


            push_val = 8'hAA; push_enable = 1; @(posedge clk); #1;
            push_val = 8'hBB; push_enable = 1; @(posedge clk); #1;
            push_val = 8'hCC; push_enable = 1; @(posedge clk); #1;
            push_enable = 0;


            pop_enable = 1; @(posedge clk); #1;

            pop_enable = 1; @(posedge clk); #1;

            pop_enable = 1; @(posedge clk); #1;
            pop_enable = 0;


            #1;



            check_outputs(1'b1, 8'hAA);
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
        input [7:0] expected_pop_val;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_pop_val === (expected_pop_val ^ pop_val ^ expected_pop_val)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, pop_val=%h",
                         empty, pop_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, pop_val=%h",
                         expected_empty, expected_pop_val);
                $display("  Got:      empty=%b, pop_val=%h",
                         empty, pop_val);
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
        $dumpvars(0,clk, pop_enable, push_enable, push_val, rst, empty, pop_val);
    end

endmodule
