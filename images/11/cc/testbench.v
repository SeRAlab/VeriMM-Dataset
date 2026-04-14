`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire [7:0] data_out;
    wire empty;
    wire full;

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
        .reset(reset),
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
            reset = 1;
            push = 0;
            pop = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single push and pop sequence", test_num);
            reset_dut();


            data_in = 8'hAA;
            push = 1;
            @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(8'hAA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test %0d: Fill stack to maximum capacity", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 1;
                push = 1;
                @(posedge clk);
                #1;
            end
            push = 0;


            #1;



            check_outputs(8'h08, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: LIFO logic verification (Push A, B, C -> Pop C)", test_num);
            reset_dut();


            data_in = 8'h10; push = 1; @(posedge clk); #1;

            data_in = 8'h20; push = 1; @(posedge clk); #1;

            data_in = 8'h30; push = 1; @(posedge clk); #1;
            push = 0;


            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(8'h30, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test %0d: Pop all items from full stack", test_num);
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i; push = 1; @(posedge clk); #1;
            end
            push = 0;


            for (i = 1; i <= 8; i = i + 1) begin
                pop = 1; @(posedge clk); #1;
            end
            pop = 0;


            #1;



            check_outputs(8'h01, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test %0d: Overflow condition (Push 9 items)", test_num);
            reset_dut();


            for (i = 1; i <= 9; i = i + 1) begin
                data_in = i; push = 1; @(posedge clk); #1;
            end
            push = 0;


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Underflow condition (Pop from empty)", test_num);
            reset_dut();

            pop = 1;
            @(posedge clk);
            #1 pop = 0;


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
        $dumpvars(0,clk, data_in, pop, push, reset, data_out, empty, full);
    end

endmodule
