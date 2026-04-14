`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] mem_addr;
    reg reset;
    reg start;
    wire busy;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .mem_addr(mem_addr),
        .reset(reset),
        .start(start),
        .busy(busy),
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
            $display("Resetting the system...");
            reset = 1;
            start = 0;
            data_in = 8'h00;
            mem_addr = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Single Data Transfer", test_num);
            reset_dut();


            mem_addr = 8'h10;
            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            while (!done) @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transfer with Different Data/Address", test_num);
            reset_dut();


            mem_addr = 8'hF0;
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            while (!done) @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Transfers", test_num);
            reset_dut();


            mem_addr = 8'h01;
            data_in = 8'h11;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            while (!done) @(posedge clk);


            @(posedge clk);
            #1;
            mem_addr = 8'h02;
            data_in = 8'h22;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h22, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Transfer", test_num);
            reset_dut();


            mem_addr = 8'h88;
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            while (!busy) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_busy;
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, done=%b",
                         busy, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, done=%b",
                         expected_busy, expected_data_out, expected_done);
                $display("  Got:      busy=%b, data_out=%h, done=%b",
                         busy, data_out, done);
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
        $dumpvars(0,clk, data_in, mem_addr, reset, start, busy, data_out, done);
    end

endmodule
