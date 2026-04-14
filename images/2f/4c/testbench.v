`timescale 1ns/1ps

module nvme_cmd_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] cmd_in;
    reg dequeue;
    reg enqueue;
    reg rst_n;
    wire [3:0] cmd_count;
    wire [7:0] cmd_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_cmd_queue dut (
        .clk(clk),
        .cmd_in(cmd_in),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .rst_n(rst_n),
        .cmd_count(cmd_count),
        .cmd_out(cmd_out),
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
            rst_n = 0;
            enqueue = 0;
            dequeue = 0;
            cmd_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Enqueue", test_num);
            reset_dut();

            cmd_in = 8'hA5;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h1, 8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enqueue and Dequeue Sequence", test_num);
            reset_dut();


            cmd_in = 8'h11;
            enqueue = 1;
            @(posedge clk);
            #1

            cmd_in = 8'h22;
            @(posedge clk);
            #1 enqueue = 0;


            dequeue = 1;
            @(posedge clk);
            #1 dequeue = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h1, 8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Queue to Capacity", test_num);
            reset_dut();

            enqueue = 1;
            for (i = 0; i < 15; i = i + 1) begin
                cmd_in = i + 8'h10;
                @(posedge clk);
                #1;
            end
            enqueue = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'hF, 8'h10, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow Protection", test_num);
            reset_dut();

            dequeue = 1;
            @(posedge clk);
            #1 dequeue = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Empty Transition", test_num);
            reset_dut();


            enqueue = 1;
            cmd_in = 8'hAA; @(posedge clk); #1;
            cmd_in = 8'hBB; @(posedge clk); #1;
            cmd_in = 8'hCC; @(posedge clk); #1;
            enqueue = 0;


            dequeue = 1;
            repeat(3) @(posedge clk);
            #1 dequeue = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_cmd_queue Testbench");
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
        input [3:0] expected_cmd_count;
        input [7:0] expected_cmd_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_cmd_count === (expected_cmd_count ^ cmd_count ^ expected_cmd_count) &&
                expected_cmd_out === (expected_cmd_out ^ cmd_out ^ expected_cmd_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: cmd_count=%h, cmd_out=%h, empty=%b, full=%b",
                         cmd_count, cmd_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_count=%h, cmd_out=%h, empty=%b, full=%b",
                         expected_cmd_count, expected_cmd_out, expected_empty, expected_full);
                $display("  Got:      cmd_count=%h, cmd_out=%h, empty=%b, full=%b",
                         cmd_count, cmd_out, empty, full);
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
        $dumpvars(0,clk, cmd_in, dequeue, enqueue, rst_n, cmd_count, cmd_out, empty, full);
    end

endmodule
