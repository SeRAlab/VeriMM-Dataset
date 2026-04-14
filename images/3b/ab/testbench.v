`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg dequeue;
    reg enqueue;
    reg rst;
    wire [7:0] data_out;
    wire empty;
    wire full;

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
            data_in = 8'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Enqueue Flags", test_num);
            reset_dut();

            data_in = 8'hAA;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;


            #1;



            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single Enqueue and Dequeue", test_num);
            reset_dut();


            data_in = 8'h55;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;


            @(posedge clk);
            #1 dequeue = 1;
            @(posedge clk);
            #1 dequeue = 0;


            #1;



            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill FIFO to Full", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 1;
                enqueue = 1;
                @(posedge clk);
                #1;
            end
            enqueue = 0;


            #1;



            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: FIFO Data Order Check", test_num);
            reset_dut();


            data_in = 8'h11; enqueue = 1; @(posedge clk); #1;

            data_in = 8'h22; enqueue = 1; @(posedge clk); #1;
            enqueue = 0;


            dequeue = 1; @(posedge clk); #1;
            dequeue = 0;


            #1;



            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Fill then Empty Completely", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 8'h10;
                enqueue = 1;
                @(posedge clk);
                #1;
            end
            enqueue = 0;


            for (i = 0; i < 8; i = i + 1) begin
                dequeue = 1;
                @(posedge clk);
                #1;
            end
            dequeue = 0;


            #1;



            check_outputs(8'h17, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Overflow Protection Check", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                data_in = i;
                enqueue = 1;
                @(posedge clk);
                #1;
            end

            data_in = 8'hFF;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Underflow Protection Check", test_num);
            reset_dut();


            dequeue = 1;
            @(posedge clk);
            #1 dequeue = 0;


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            data_in = 8'hA1;
            enqueue = 1;
            @(posedge clk);
            #1 enqueue = 0;


            data_in = 8'hB2;
            enqueue = 1;
            dequeue = 1;
            @(posedge clk);
            #1;
            enqueue = 0;
            dequeue = 0;



            #1;




            check_outputs(8'hA1, 1'b0, 1'b0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, dequeue, enqueue, rst, data_out, empty, full);
    end

endmodule
