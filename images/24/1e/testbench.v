`timescale 1ns/1ps

module nvme_command_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command_id;
    reg dequeue;
    reg enqueue;
    reg rst;
    wire [3:0] command_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_queue dut (
        .clk(clk),
        .command_id(command_id),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .rst(rst),
        .command_out(command_out),
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
            rst = 1;
            enqueue = 0;
            dequeue = 0;
            command_id = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Single Enqueue and Dequeue");
            reset_dut();


            command_id = 4'hA;
            enqueue = 1;
            @(posedge clk);
            enqueue = 0;
            @(posedge clk);


            dequeue = 1;
            @(posedge clk);
            dequeue = 0;
            #1;


            #1;



            check_outputs(4'hA, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Fill Queue to Capacity");
            reset_dut();


            command_id = 4'h1; enqueue = 1; @(posedge clk);
            command_id = 4'h2; enqueue = 1; @(posedge clk);
            command_id = 4'h3; enqueue = 1; @(posedge clk);
            command_id = 4'h4; enqueue = 1; @(posedge clk);
            enqueue = 0;
            #1;


            #1;



            check_outputs(4'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Verify FIFO Order");
            reset_dut();


            command_id = 4'hC; enqueue = 1; @(posedge clk);
            command_id = 4'hD; enqueue = 1; @(posedge clk);
            enqueue = 0;
            @(posedge clk);


            dequeue = 1;
            @(posedge clk);
            dequeue = 0;
            #1;


            #1;



            check_outputs(4'hC, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Overflow Check");
            reset_dut();


            command_id = 4'h1; enqueue = 1; @(posedge clk);
            command_id = 4'h2; enqueue = 1; @(posedge clk);
            command_id = 4'h3; enqueue = 1; @(posedge clk);
            command_id = 4'h4; enqueue = 1; @(posedge clk);


            command_id = 4'hE; enqueue = 1; @(posedge clk);
            enqueue = 0;
            #1;


            #1;



            check_outputs(4'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Empty Queue Dequeue");
            reset_dut();


            dequeue = 1;
            @(posedge clk);
            dequeue = 0;
            #1;


            #1;



            check_outputs(command_out, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Pointer Wrap-around Test");
            reset_dut();


            command_id = 4'h1; enqueue = 1; @(posedge clk);
            command_id = 4'h2; enqueue = 1; @(posedge clk);
            enqueue = 0; dequeue = 1; @(posedge clk);
            dequeue = 1; @(posedge clk);
            dequeue = 0;


            command_id = 4'hA; enqueue = 1; @(posedge clk);
            command_id = 4'hB; enqueue = 1; @(posedge clk);
            command_id = 4'hC; enqueue = 1; @(posedge clk);
            enqueue = 0;
            #1;


            #1;



            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_queue Testbench");
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
        input [3:0] expected_command_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_command_out === (expected_command_out ^ command_out ^ expected_command_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: command_out=%h, empty=%b, full=%b",
                         command_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_out=%h, empty=%b, full=%b",
                         expected_command_out, expected_empty, expected_full);
                $display("  Got:      command_out=%h, empty=%b, full=%b",
                         command_out, empty, full);
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
        $dumpvars(0,clk, command_id, dequeue, enqueue, rst, command_out, empty, full);
    end

endmodule
