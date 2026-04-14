`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg dequeue;
    reg enqueue;
    reg rst;
    wire [7:0] data_out;
    wire is_empty;
    wire is_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .rst(rst),
        .data_out(data_out),
        .is_empty(is_empty),
        .is_full(is_full)
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
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Enqueue", test_num);
            reset_dut();

            data_in = 8'hA5;
            enqueue = 1;
            @(posedge clk);
            #1;
            enqueue = 0;


            #1;



            check_outputs(8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill to Full (Depth 8)", test_num);
            reset_dut();

            enqueue = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 1;
                @(posedge clk);
                #1;
            end
            enqueue = 0;


            #1;



            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: FIFO Data Order Integrity", test_num);
            reset_dut();


            enqueue = 1;
            data_in = 8'h11; @(posedge clk); #1;
            data_in = 8'h22; @(posedge clk); #1;
            data_in = 8'h33; @(posedge clk); #1;
            enqueue = 0;


            dequeue = 1;
            @(posedge clk);
            #1;
            dequeue = 0;


            #1;



            check_outputs(8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Full to Empty Transition", test_num);
            reset_dut();


            enqueue = 1;
            for (i = 0; i < 4; i = i + 1) begin
                data_in = 8'hF0 + i;
                @(posedge clk); #1;
            end
            enqueue = 0;


            dequeue = 1;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk); #1;
            end
            dequeue = 0;


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Enqueue and Dequeue", test_num);
            reset_dut();


            enqueue = 1;
            data_in = 8'hCC;
            @(posedge clk); #1;


            data_in = 8'hDD;
            enqueue = 1;
            dequeue = 1;
            @(posedge clk); #1;
            enqueue = 0;
            dequeue = 0;


            #1;



            check_outputs(8'hDD, 1'b0, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_is_empty;
        input expected_is_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_is_empty === (expected_is_empty ^ is_empty ^ expected_is_empty) &&
                expected_is_full === (expected_is_full ^ is_full ^ expected_is_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, is_empty=%b, is_full=%b",
                         data_out, is_empty, is_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, is_empty=%b, is_full=%b",
                         expected_data_out, expected_is_empty, expected_is_full);
                $display("  Got:      data_out=%h, is_empty=%b, is_full=%b",
                         data_out, is_empty, is_full);
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
        $dumpvars(0,clk, data_in, dequeue, enqueue, rst, data_out, is_empty, is_full);
    end

endmodule
