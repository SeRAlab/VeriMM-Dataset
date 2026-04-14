`timescale 1ns/1ps

module LIFO_stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire empty;
    wire full;
    wire [3:0] top_data;

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
        .reset(reset),
        .empty(empty),
        .full(full),
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
            push = 0;
            pop = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 4'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Push operation", test_num);
            reset_dut();

            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            #1 push = 0;
            data_in = 0;


            #1;



            check_outputs(1'b0, 1'b0, 4'hA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill stack to full", test_num);
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                push = 1;
                @(posedge clk);
                #1;
            end
            push = 0;


            #1;



            check_outputs(1'b0, 1'b1, 4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Push A, Push B, Pop B, Check Top is A", test_num);
            reset_dut();


            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            #1;

            data_in = 4'hB;
            push = 1;
            @(posedge clk);
            #1;
            push = 0;

            pop = 1;
            @(posedge clk);
            #1;
            pop = 0;


            #1;



            check_outputs(1'b0, 1'b0, 4'hA);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill then Empty stack", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                data_in = i;
                push = 1;
                @(posedge clk);
                #1;
            end
            push = 0;


            pop = 1;
            repeat(8) @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(1'b1, 1'b0, 4'bx);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow check (9 pushes for depth 8)", test_num);
            reset_dut();


            for (i = 1; i <= 9; i = i + 1) begin
                data_in = i;
                push = 1;
                @(posedge clk);
                #1;
            end
            push = 0;


            #1;



            check_outputs(1'b0, 1'b1, 4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple pushes, check top stability", test_num);
            reset_dut();

            data_in = 4'h5;
            push = 1; @(posedge clk); #1;
            data_in = 4'h3;
            push = 1; @(posedge clk); #1;
            data_in = 4'hF;
            push = 1; @(posedge clk); #1;
            push = 0;


            repeat(3) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 4'hF);
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
        input expected_empty;
        input expected_full;
        input [3:0] expected_top_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_top_data === (expected_top_data ^ top_data ^ expected_top_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, top_data=%h",
                         empty, full, top_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, top_data=%h",
                         expected_empty, expected_full, expected_top_data);
                $display("  Got:      empty=%b, full=%b, top_data=%h",
                         empty, full, top_data);
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
        $dumpvars(0,clk, data_in, pop, push, reset, empty, full, top_data);
    end

endmodule
