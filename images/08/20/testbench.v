`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire is_empty;
    wire [3:0] top;

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
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial State Check");
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(1'b1, 4'hx);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Push and Peek");
            test_num = 2;
            reset_dut();
            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            #1;
            push = 0;
            #1;

            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Push then Pop");
            test_num = 3;
            reset_dut();

            data_in = 4'h5;
            push = 1;
            @(posedge clk);
            #1 push = 0;

            @(posedge clk);
            pop = 1;
            #1;
            @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(1'b1, 4'hx);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: LIFO Order Check");
            test_num = 4;
            reset_dut();

            data_in = 4'h1; push = 1; @(posedge clk);
            #1 data_in = 4'h2; push = 1; @(posedge clk);
            #1 data_in = 4'h3; push = 1; @(posedge clk);
            #1 push = 0;

            @(posedge clk);
            pop = 1;
            #1;
            @(posedge clk);
            #1 pop = 0;

            #1;


            check_outputs(1'b0, 4'h2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Fill to Capacity");
            test_num = 5;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i[3:0];
                push = 1;
                @(posedge clk);
                #1;
            end
            push = 0;

            #1;


            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("\nRunning testcase006: Fill then Empty Completely");
            test_num = 6;
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i[3:0];
                push = 1; @(posedge clk); #1;
            end
            push = 0;

            for (i = 0; i < 8; i = i + 1) begin
                pop = 1; @(posedge clk); #1;
            end
            pop = 0;
            #1;

            check_outputs(1'b1, 4'hx);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Interleaved Operations");
            test_num = 7;
            reset_dut();

            data_in = 4'hA; push = 1; @(posedge clk); #1;
            data_in = 4'hB; push = 1; @(posedge clk); #1;
            push = 0; pop = 1; @(posedge clk); #1;
            pop = 0; data_in = 4'hC; push = 1; @(posedge clk); #1;
            push = 0;

            #1;


            check_outputs(1'b0, 4'hC);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Underflow Test");
            test_num = 8;
            reset_dut();

            pop = 1; @(posedge clk); #1;
            @(posedge clk); #1;
            pop = 0;

            #1;


            check_outputs(1'b1, 4'hx);
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
        input expected_is_empty;
        input [3:0] expected_top;
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
