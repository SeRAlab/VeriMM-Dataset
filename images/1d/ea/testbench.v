`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire [3:0] data_out;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .reset(reset),
        .data_out(data_out),
        .empty(empty)
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
            $display("Running testcase001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'bxxxx, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Push Check");
            test_num = 2;
            reset_dut();

            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            #1 push = 0;
            @(posedge clk);


            #1;



            check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Push then Pop Check");
            test_num = 3;
            reset_dut();


            data_in = 4'h5;
            push = 1;
            @(posedge clk);
            #1 push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);


            #1;



            check_outputs(4'bxxxx, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple Pushes (FIFO Order) Check");
            test_num = 4;
            reset_dut();


            data_in = 4'h1;
            push = 1;
            @(posedge clk);
            #1;


            data_in = 4'h2;
            push = 1;
            @(posedge clk);
            #1 push = 0;
            @(posedge clk);


            pop = 1;
            @(posedge clk);
            #1 pop = 0;
            @(posedge clk);



            #1;




            check_outputs(4'h2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full Sequence Check");
            test_num = 5;
            reset_dut();


            data_in = 4'h7; push = 1; @(posedge clk); #1;
            data_in = 4'h8; push = 1; @(posedge clk); #1;
            data_in = 4'h9; push = 1; @(posedge clk); #1 push = 0;
            @(posedge clk);


            pop = 1; @(posedge clk); #1;
            pop = 1; @(posedge clk); #1;
            pop = 1; @(posedge clk); #1 pop = 0;
            @(posedge clk);


            #1;



            check_outputs(4'bxxxx, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_data_out;
        input expected_empty;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b",
                         data_out, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b",
                         expected_data_out, expected_empty);
                $display("  Got:      data_out=%h, empty=%b",
                         data_out, empty);
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
        $dumpvars(0,clk, data_in, pop, push, reset, data_out, empty);
    end

endmodule
