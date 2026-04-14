`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire full;

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
        .data_out(data_out),
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
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Basic Push then Pop", test_num);


            data_in = 8'hA5;
            push = 1;
            @(posedge clk);
            push = 0;


            @(posedge clk);
            pop = 1;
            @(posedge clk);
            pop = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Fill stack to capacity", test_num);

            push = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            push = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h08, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: LIFO order check (Push A, Push B, Pop)", test_num);


            data_in = 8'h11;
            push = 1;
            @(posedge clk);

            data_in = 8'h22;
            @(posedge clk);
            push = 0;


            @(posedge clk);
            pop = 1;
            @(posedge clk);
            pop = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: LIFO sequence (Push 1, 2, 3 -> Pop, Pop)", test_num);

            push = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            push = 0;

            @(posedge clk);
            pop = 1;
            @(posedge clk);
            @(posedge clk);
            pop = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h02, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Overflow check (Push 9 elements)", test_num);

            push = 1;
            for (i = 1; i <= 9; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            push = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h08, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Transition from full to not full", test_num);


            push = 1;
            data_in = 8'hFF;
            repeat(8) @(posedge clk);
            push = 0;


            @(posedge clk);
            pop = 1;
            @(posedge clk);
            pop = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, full=%b",
                         data_out, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, full=%b",
                         expected_data_out, expected_full);
                $display("  Got:      data_out=%h, full=%b",
                         data_out, full);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, full);
    end

endmodule
