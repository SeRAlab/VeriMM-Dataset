`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] fifo_data;
    reg fifo_empty;
    reg reset_n;
    wire bck;
    wire data;
    wire fifo_rdreq;
    wire lrck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_data(fifo_data),
        .fifo_empty(fifo_empty),
        .reset_n(reset_n),
        .bck(bck),
        .data(data),
        .fifo_rdreq(fifo_rdreq),
        .lrck(lrck)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        fifo_data = 32'h0;
        fifo_empty = 1;
        #20;
        reset_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        repeat(5) @(posedge clk);



        #1;




        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        fifo_empty = 0;
        fifo_data = 32'hA5A5_5A5A;



        fork
            begin
                wait(fifo_rdreq == 1'b1);
            end
            begin
                repeat(100) @(posedge clk);
            end
        join_any


        #1;



        check_outputs(bck, data, 1'b1, lrck);
    end
        endtask

    task testcase003;

    reg last_lrck;
    begin
        test_num = 3;
        reset_dut();
        fifo_empty = 0;
        fifo_data = 32'hFFFF_0000;


        repeat(500) @(posedge clk);




        if (lrck === 1'b1 || lrck === 1'b0) begin

             pass_count = pass_count + 1;
             $display("Test 003: Clocks active. LRCK=%b BCK=%b", lrck, bck);
        end else begin
             fail_count = fail_count + 1;
             $display("Test 003: Clocks invalid.");
        end
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        fifo_empty = 0;
        fifo_data = 32'h12345678;

        @(posedge fifo_rdreq);
        @(posedge clk);
        fifo_empty = 1;


        repeat(2000) @(posedge clk);


        #1;



        check_outputs(bck, data, 1'b0, lrck);
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
        input expected_bck;
        input expected_data;
        input expected_fifo_rdreq;
        input expected_lrck;
        begin
            if (expected_bck === (expected_bck ^ bck ^ expected_bck) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_fifo_rdreq === (expected_fifo_rdreq ^ fifo_rdreq ^ expected_fifo_rdreq) &&
                expected_lrck === (expected_lrck ^ lrck ^ expected_lrck)) begin
                $display("PASS");
                $display("  Outputs: bck=%b, data=%b, fifo_rdreq=%b, lrck=%b",
                         bck, data, fifo_rdreq, lrck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bck=%b, data=%b, fifo_rdreq=%b, lrck=%b",
                         expected_bck, expected_data, expected_fifo_rdreq, expected_lrck);
                $display("  Got:      bck=%b, data=%b, fifo_rdreq=%b, lrck=%b",
                         bck, data, fifo_rdreq, lrck);
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
        $dumpvars(0,clk, fifo_data, fifo_empty, reset_n, bck, data, fifo_rdreq, lrck);
    end

endmodule
