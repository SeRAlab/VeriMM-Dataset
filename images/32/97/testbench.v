`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [7:0] data_out;
    wire is_empty;
    wire is_full;

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
        .is_empty(is_empty),
        .is_full(is_full)
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
        test_num = test_num + 1;
        $display("Test Case %0d: Initial State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Push", test_num);
        reset_dut();

        data_in = 8'hA5;
        push = 1;
        @(posedge clk);
        #1;
        push = 0;


        #1;



        check_outputs(8'hA5, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Push then Pop", test_num);
        reset_dut();


        data_in = 8'h55;
        push = 1;
        @(posedge clk);
        #1;
        push = 0;


        pop = 1;
        @(posedge clk);
        #1;
        pop = 0;


        #1;



        check_outputs(8'h55, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

        integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Fill Stack to Capacity", test_num);
        reset_dut();


        for (i = 1; i <= 8; i = i + 1) begin
            data_in = i;
            push = 1;
            @(posedge clk);
            #1;
        end
        push = 0;


        #1;



        check_outputs(8'h08, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LIFO Ordering Check", test_num);
        reset_dut();


        data_in = 8'h11;
        push = 1;
        @(posedge clk);
        #1;

        data_in = 8'h22;
        push = 1;
        @(posedge clk);
        #1;

        data_in = 8'h33;
        push = 1;
        @(posedge clk);
        #1;
        push = 0;


        pop = 1;
        @(posedge clk);
        #1;
        pop = 0;


        #1;



        check_outputs(8'h22, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pop Empty Stack (Underflow)", test_num);
        reset_dut();


        pop = 1;
        @(posedge clk);
        #1;
        pop = 0;


        #1;



        check_outputs(8'h00, 1'b1, 1'b0);
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
        input expected_is_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_is_empty === (expected_is_empty ^ is_empty ^ expected_is_empty) &&
                expected_is_full === (expected_is_full ^ is_full ^ expected_is_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, is_empty=%b, is_full=%b",
                         data_out, is_empty, is_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, is_empty=%b, is_full=%b",
                         expected_data_out, expected_is_empty, expected_is_full);
                $display("  Got:      data_out=%h, is_empty=%b, is_full=%b",
                         data_out, is_empty, is_full);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, is_empty, is_full);
    end

endmodule
