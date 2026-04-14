`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop;
    reg push;
    reg [7:0] push_data;
    reg rst;
    wire empty;
    wire [7:0] pop_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack dut (
        .clk(clk),
        .pop(pop),
        .push(push),
        .push_data(push_data),
        .rst(rst),
        .empty(empty),
        .pop_data(pop_data)
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
            push_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial State");
            reset_dut();

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Push and Pop");
            reset_dut();


            push = 1;
            push_data = 8'hA5;
            @(posedge clk);
            push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;


            #1;



            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: LIFO order check");
            reset_dut();


            push = 1; push_data = 8'h11;
            @(posedge clk);

            push_data = 8'h22;
            @(posedge clk);
            push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;


            #1;



            check_outputs(1'b0, 8'h22);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running Testcase 004: Fill stack to max capacity");
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                push = 1;
                push_data = i;
                @(posedge clk);
            end
            push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            pop = 0;
            #1;


            #1;



            check_outputs(1'b0, 8'h08);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running Testcase 005: Sequence to empty");
            reset_dut();


            push = 1; push_data = 8'hAA; @(posedge clk);
            push = 1; push_data = 8'hBB; @(posedge clk);
            push = 1; push_data = 8'hCC; @(posedge clk);
            push = 0;


            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 1; @(posedge clk);
            pop = 0;
            #1;


            #1;



            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Interleaved operations");
            reset_dut();

            push = 1; push_data = 8'h01; @(posedge clk);
            push = 1; push_data = 8'h02; @(posedge clk);
            pop = 1; push = 0; @(posedge clk);
            push = 1; push_data = 8'h03; pop = 0; @(posedge clk);
            pop = 1; push = 0; @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h03);
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
        input expected_empty;
        input [7:0] expected_pop_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_pop_data === (expected_pop_data ^ pop_data ^ expected_pop_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, pop_data=%h",
                         empty, pop_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, pop_data=%h",
                         expected_empty, expected_pop_data);
                $display("  Got:      empty=%b, pop_data=%h",
                         empty, pop_data);
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
        $dumpvars(0,clk, pop, push, push_data, rst, empty, pop_data);
    end

endmodule
