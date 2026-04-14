`timescale 1ns/1ps

module LinkedListTraversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedListTraversal dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Traversal...");
            test_num = 1;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;



            fork
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any


            #2;



            #1;




            check_outputs(8'h03, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Reset during Traversal...");
            test_num = 2;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(3) @(posedge clk);
            reset = 1;
            #10;
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Repeated Traversal...");
            test_num = 3;


            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1'b1);


            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any

            #2;

            #1;


            check_outputs(8'h03, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Single-cycle Start Pulse...");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            fork
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any

            #2;
            #1;

            check_outputs(8'h03, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinkedListTraversal Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, reset, start, data_out, done);
    end

endmodule
