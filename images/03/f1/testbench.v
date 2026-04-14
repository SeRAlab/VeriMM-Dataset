`timescale 1ns/1ps

module LIFO_Stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire is_empty;
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
        .rst(rst),
        .is_empty(is_empty),
        .top(top)
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
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Push Single Element", test_num);
            reset_dut();
            data_in = 8'hAA;
            push = 1;
            @(posedge clk);
            #1 push = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: LIFO Peek Check", test_num);
            reset_dut();

            data_in = 8'h11;
            push = 1;
            @(posedge clk);

            #1 data_in = 8'h22;
            @(posedge clk);
            #1 push = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Push and Pop Check", test_num);
            reset_dut();

            data_in = 8'h11; push = 1;
            @(posedge clk);

            #1 data_in = 8'h22;
            @(posedge clk);

            #1 push = 0; pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Fill Stack to Capacity", test_num);
            reset_dut();
            push = 1;
            data_in = 8'h01; @(posedge clk);
            #1 data_in = 8'h02; @(posedge clk);
            #1 data_in = 8'h03; @(posedge clk);
            #1 data_in = 8'h04; @(posedge clk);
            #1 push = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Empty check after full cycle", test_num);
            reset_dut();

            push = 1;
            data_in = 8'hA1; @(posedge clk);
            #1 data_in = 8'hA2; @(posedge clk);
            #1 data_in = 8'hA3; @(posedge clk);
            #1 data_in = 8'hA4; @(posedge clk);

            #1 push = 0; pop = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Interleaved Operations", test_num);
            reset_dut();

            data_in = 8'hDE; push = 1; @(posedge clk);

            #1 data_in = 8'hAD; @(posedge clk);

            #1 push = 0; pop = 1; @(posedge clk);

            #1 pop = 0; push = 1; data_in = 8'hBE; @(posedge clk);
            #1 push = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hBE);
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
        input expected_is_empty;
        input [7:0] expected_top;
        begin
            if (expected_is_empty === (expected_is_empty ^ is_empty ^ expected_is_empty) &&
                expected_top === (expected_top ^ top ^ expected_top)) begin
                $display("PASS");
                $display("  Outputs: is_empty=%b, top=%h",
                         is_empty, top);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_empty=%b, top=%h",
                         expected_is_empty, expected_top);
                $display("  Got:      is_empty=%b, top=%h",
                         is_empty, top);
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
        $dumpvars(0,clk, data_in, pop, push, rst, is_empty, top);
    end

endmodule
