`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire empty;
    wire [7:0] top;

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
        .reset(reset),
        .empty(empty),
        .top(top)
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
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 8'hxx);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Push", test_num);
            reset_dut();
            push = 1;
            data_in = 8'hA5;
            @(posedge clk);
            push = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LIFO Ordering Check", test_num);
            reset_dut();

            push = 1; data_in = 8'h11; @(posedge clk);

            push = 1; data_in = 8'h22; @(posedge clk);
            push = 0; @(posedge clk);

            pop = 1; @(posedge clk);
            pop = 0; @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill to Capacity", test_num);
            reset_dut();
            push = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            push = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle (Push 4, Pop 4)", test_num);
            reset_dut();

            push = 1;
            data_in = 8'hD1; @(posedge clk);
            data_in = 8'hD2; @(posedge clk);
            data_in = 8'hD3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);
            push = 0;

            pop = 1;
            repeat(4) @(posedge clk);
            pop = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hxx);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow (Pop empty stack)", test_num);
            reset_dut();
            pop = 1;
            repeat(2) @(posedge clk);
            pop = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hxx);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow (Push more than 4 items)", test_num);
            reset_dut();
            push = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            push = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h04);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Push/Pop", test_num);
            reset_dut();
            push = 1; data_in = 8'hAA; @(posedge clk);
            push = 1; data_in = 8'hBB; @(posedge clk);
            push = 0; pop = 1;          @(posedge clk);
            pop = 0; push = 1; data_in = 8'hCC; @(posedge clk);
            push = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hCC);
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
        testcase008();
        
        
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
        input [7:0] expected_top;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_top === (expected_top ^ top ^ expected_top)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, top=%h",
                         empty, top);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, top=%h",
                         expected_empty, expected_top);
                $display("  Got:      empty=%b, top=%h",
                         empty, top);
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
        $dumpvars(0,clk, data_in, pop, push, reset, empty, top);
    end

endmodule
