`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire is_empty;

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
        .is_empty(is_empty)
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
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial State after Reset", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Single Push and Peek", test_num);
        reset_dut();


        data_in = 8'hA5;
        push = 1;
        @(posedge clk);
        push = 0;
        @(posedge clk);


        #1;



        check_outputs(8'hA5, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: LIFO Order - Multiple Push then Pop", test_num);
        reset_dut();


        data_in = 8'h11; push = 1; @(posedge clk);

        data_in = 8'h22; push = 1; @(posedge clk);

        data_in = 8'h33; push = 1; @(posedge clk);
        push = 0;


        pop = 1;
        @(posedge clk);
        pop = 0;
        @(posedge clk);



        #1;




        check_outputs(8'h22, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Test %0d: Fill Stack to Capacity (8 items)", test_num);
        reset_dut();


        for (i = 1; i <= 8; i = i + 1) begin
            data_in = i;
            push = 1;
            @(posedge clk);
        end
        push = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h08, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Test %0d: Pop until Empty", test_num);
        reset_dut();


        data_in = 8'hAA; push = 1; @(posedge clk);
        data_in = 8'hBB; push = 1; @(posedge clk);
        push = 0;


        pop = 1; @(posedge clk);
        pop = 1; @(posedge clk);
        pop = 0;
        @(posedge clk);


        #1;



        check_outputs(data_out, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Underflow Check (Pop on Empty)", test_num);
        reset_dut();


        pop = 1;
        @(posedge clk);
        pop = 0;
        @(posedge clk);


        #1;



        check_outputs(data_out, 1'b1);
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
        input expected_is_empty;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_is_empty === (expected_is_empty ^ is_empty ^ expected_is_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, is_empty=%b",
                         data_out, is_empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, is_empty=%b",
                         expected_data_out, expected_is_empty);
                $display("  Got:      data_out=%h, is_empty=%b",
                         data_out, is_empty);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, is_empty);
    end

endmodule
