`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop;
    reg push;
    reg [7:0] push_data;
    reg reset;
    wire empty;
    wire full;
    wire [7:0] pop_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LIFO_Stack dut (
        .clk(clk),
        .pop(pop),
        .push(push),
        .push_data(push_data),
        .reset(reset),
        .empty(empty),
        .full(full),
        .pop_data(pop_data)
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
            push_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Push and Pop", test_num);
            reset_dut();


            push = 1; push_data = 8'hA5;
            @(posedge clk);
            push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 8'hA5);
            pop = 0;
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Fill stack to check Full Flag", test_num);
            reset_dut();

            push = 1;
            for (i = 0; i < 8; i = i + 1) begin
                push_data = i + 1;
                @(posedge clk);
            end
            push = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 8'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Verify Empty Flag after Reset", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: LIFO Order Verification", test_num);
            reset_dut();


            push = 1; push_data = 8'h11; @(posedge clk);
            push = 1; push_data = 8'h22; @(posedge clk);
            push = 1; push_data = 8'h33; @(posedge clk);
            push = 0; @(posedge clk);


            pop = 1; @(posedge clk);

            pop = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 1'b0, 8'h22);
            pop = 0;
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Stack Overflow Test", test_num);
            reset_dut();


            push = 1;
            for (i = 0; i < 8; i = i + 1) begin
                push_data = i;
                @(posedge clk);
            end

            push_data = 8'hFF;
            @(posedge clk);
            push = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 1'b1, 8'h07);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Stack Underflow Test", test_num);
            reset_dut();

            pop = 1;
            @(posedge clk);
            pop = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_pop_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_pop_data === (expected_pop_data ^ pop_data ^ expected_pop_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, pop_data=%h",
                         empty, full, pop_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, pop_data=%h",
                         expected_empty, expected_full, expected_pop_data);
                $display("  Got:      empty=%b, full=%b, pop_data=%h",
                         empty, full, pop_data);
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
        $dumpvars(0,clk, pop, push, push_data, reset, empty, full, pop_data);
    end

endmodule
