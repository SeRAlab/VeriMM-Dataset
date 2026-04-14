`timescale 1ns/1ps

module NVMeQueueManager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] command_in;
    reg dequeue;
    reg enqueue;
    reg rst_n;
    wire [31:0] command_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMeQueueManager dut (
        .clk(clk),
        .command_in(command_in),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .rst_n(rst_n),
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
        rst_n = 0;
        enqueue = 0;
        dequeue = 0;
        command_in = 32'h0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial State after Reset", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Single Enqueue operation", test_num);
        reset_dut();
        command_in = 32'hA1A1_A1A1;
        enqueue = 1;
        @(posedge clk);
        #1 enqueue = 0;

        #1;


        check_outputs(32'hA1A1_A1A1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Fill queue to full (4 items)", test_num);
        reset_dut();


        @(posedge clk);
        command_in = 32'h1111_1111; enqueue = 1; @(posedge clk);
        command_in = 32'h2222_2222; enqueue = 1; @(posedge clk);
        command_in = 32'h3333_3333; enqueue = 1; @(posedge clk);
        command_in = 32'h4444_4444; enqueue = 1; @(posedge clk);
        #1 enqueue = 0;


        #1;



        check_outputs(32'h1111_1111, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Verify FIFO ordering", test_num);
        reset_dut();


        command_in = 32'hAAAA_AAAA; enqueue = 1; @(posedge clk);
        command_in = 32'hBBBB_BBBB; enqueue = 1; @(posedge clk);
        #1 enqueue = 0;


        dequeue = 1; @(posedge clk);
        #1 dequeue = 0;


        #1;



        check_outputs(32'hBBBB_BBBB, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Fill 2 and drain until empty", test_num);
        reset_dut();

        command_in = 32'hC1C1_C1C1; enqueue = 1; @(posedge clk);
        command_in = 32'hC2C2_C2C2; enqueue = 1; @(posedge clk);
        #1 enqueue = 0;

        dequeue = 1; @(posedge clk);
        @(posedge clk);
        #1 dequeue = 0;


        #1;



        check_outputs(32'hC2C2_C2C2, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Enqueue into full queue (Overflow)", test_num);
        reset_dut();


        command_in = 32'h1; enqueue = 1; @(posedge clk);
        command_in = 32'h2; enqueue = 1; @(posedge clk);
        command_in = 32'h3; enqueue = 1; @(posedge clk);
        command_in = 32'h4; enqueue = 1; @(posedge clk);


        command_in = 32'h99; enqueue = 1; @(posedge clk);
        #1 enqueue = 0;


        #1;



        check_outputs(32'h1, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Dequeue from empty queue (Underflow)", test_num);
        reset_dut();


        dequeue = 1; @(posedge clk);
        #1 dequeue = 0;


        #1;



        check_outputs(32'h0, 1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMeQueueManager Testbench");
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
        input [31:0] expected_command_out;
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
        $dumpvars(0,clk, command_in, dequeue, enqueue, rst_n, command_out, empty, full);
    end

endmodule
