`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] fifo_wdata;
    reg fifo_wr;
    wire fifo_FF;
    wire [7:0] r_dat;
    wire wfifo_empty;
    wire [5:0] wfifo_used;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_wdata(fifo_wdata),
        .fifo_wr(fifo_wr),
        .fifo_FF(fifo_FF),
        .r_dat(r_dat),
        .wfifo_empty(wfifo_empty),
        .wfifo_used(wfifo_used)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            fifo_wr = 0;
            fifo_wdata = 8'h0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'hxx, 1'b1, 6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Write Operation", test_num);
            reset_dut();

            @(posedge clk);
            fifo_wr = 1;
            fifo_wdata = 8'hA5;
            @(posedge clk);
            fifo_wr = 0;
            #1;


            #1;



            check_outputs(1'b0, 8'hA5, 1'b0, 6'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Half-Full Capacity (32 entries)", test_num);



            for(i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
                fifo_wr = 1;
                fifo_wdata = i[7:0];
            end
            @(posedge clk);
            fifo_wr = 0;
            #1;



            #1;




            check_outputs(1'b0, 8'hA5, 1'b0, 6'd32);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill to Maximum (64 entries)", test_num);


            for(i = 0; i < 32; i = i + 1) begin
                @(posedge clk);
                fifo_wr = 1;
                fifo_wdata = 8'hFF;
            end
            @(posedge clk);
            fifo_wr = 0;
            #1;


            #1;



            check_outputs(1'b1, 8'hA5, 1'b0, 6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow Protection", test_num);

            @(posedge clk);
            fifo_wr = 1;
            fifo_wdata = 8'hEE;
            @(posedge clk);
            fifo_wr = 0;
            #1;


            #1;



            check_outputs(1'b1, 8'hA5, 1'b0, 6'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_fifo_FF;
        input [7:0] expected_r_dat;
        input expected_wfifo_empty;
        input [5:0] expected_wfifo_used;
        begin
            if (expected_fifo_FF === (expected_fifo_FF ^ fifo_FF ^ expected_fifo_FF) &&
                expected_r_dat === (expected_r_dat ^ r_dat ^ expected_r_dat) &&
                expected_wfifo_empty === (expected_wfifo_empty ^ wfifo_empty ^ expected_wfifo_empty) &&
                expected_wfifo_used === (expected_wfifo_used ^ wfifo_used ^ expected_wfifo_used)) begin
                $display("PASS");
                $display("  Outputs: fifo_FF=%b, r_dat=%h, wfifo_empty=%b, wfifo_used=%h",
                         fifo_FF, r_dat, wfifo_empty, wfifo_used);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_FF=%b, r_dat=%h, wfifo_empty=%b, wfifo_used=%h",
                         expected_fifo_FF, expected_r_dat, expected_wfifo_empty, expected_wfifo_used);
                $display("  Got:      fifo_FF=%b, r_dat=%h, wfifo_empty=%b, wfifo_used=%h",
                         fifo_FF, r_dat, wfifo_empty, wfifo_used);
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
        $dumpvars(0,clk, fifo_wdata, fifo_wr, fifo_FF, r_dat, wfifo_empty, wfifo_used);
    end

endmodule
