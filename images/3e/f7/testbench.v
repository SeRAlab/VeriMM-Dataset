`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire [15:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
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
            data_in = 0;
            src_addr = 0;
            dest_addr = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Data Transfer", test_num);
            reset_dut();


            src_addr = 8'h0A;
            dest_addr = 8'h50;
            data_in = 16'hCAFE;
            start = 1;


            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hCAFE, 1'b1);


            start = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Idle State (No Start)", test_num);
            reset_dut();


            src_addr = 8'h11;
            dest_addr = 8'h22;
            data_in = 16'hBEEF;
            start = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Max Value Transfer", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'hFF;
            data_in = 16'hFFFF;
            start = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF, 1'b1);

            start = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Successive Transfer Check", test_num);
            reset_dut();


            src_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 16'h1234;
            start = 1;
            @(posedge clk);
            #1;


            src_addr = 8'h03;
            dest_addr = 8'h04;
            data_in = 16'h5678;
            start = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h5678, 1'b1);

            start = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            data_in = 16'h9999;
            start = 1;


            reset = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
            reset = 0;
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, dest_addr, reset, src_addr, start, data_out, done);
    end

endmodule
