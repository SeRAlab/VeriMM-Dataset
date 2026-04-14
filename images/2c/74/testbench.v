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
        test_num = test_num + 1;
        $display("\nTestcase %0d: Initial State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Push and Pop", test_num);
        reset_dut();


        data_in = 8'hA5;
        push = 1;
        @(posedge clk);
        push = 0;
        @(posedge clk);


        pop = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5, 1'b1, 1'b0);
        pop = 0;
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: LIFO Logic Check", test_num);
        reset_dut();


        data_in = 8'h11; push = 1; @(posedge clk);

        data_in = 8'h22; push = 1; @(posedge clk);
        push = 0;
        @(posedge clk);


        pop = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h22, 1'b0, 1'b0);
        pop = 0;
        @(posedge clk);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Fill to Capacity", test_num);
        reset_dut();

        for (i = 0; i < 8; i = i + 1) begin
            data_in = i + 1;
            push = 1;
            @(posedge clk);
        end
        push = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h08, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Overflow Protection", test_num);
        reset_dut();


        for (i = 1; i <= 8; i = i + 1) begin
            data_in = i; push = 1; @(posedge clk);
        end

        data_in = 8'hFF; push = 1; @(posedge clk);
        push = 0;


        pop = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h08, 1'b0, 1'b0);
        pop = 0;
        @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Underflow Protection", test_num);
        reset_dut();

        pop = 1;
        @(posedge clk);
        pop = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Exhaustive LIFO Check", test_num);
        reset_dut();


        for (i = 1; i <= 8; i = i + 1) begin
            data_in = i << 4; push = 1; @(posedge clk);
        end
        push = 0;


        for (i = 1; i <= 8; i = i + 1) begin
            pop = 1;
            @(posedge clk);
            if (i < 8) pop = 0;
        end
        #1;

        #1;


        check_outputs(8'h10, 1'b1, 1'b0);
        pop = 0;
        @(posedge clk);
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
