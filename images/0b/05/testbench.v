`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dst_addr;
    reg rst_n;
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
        .dst_addr(dst_addr),
        .rst_n(rst_n),
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
            rst_n = 0;
            start = 0;
            src_addr = 8'h0;
            dst_addr = 8'h0;
            data_in = 16'h0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Data Transfer");
            reset_dut();
            test_num = test_num + 1;


            src_addr = 8'h10;
            dst_addr = 8'h20;
            data_in = 16'hABCD;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            fork
                begin
                    wait(done == 1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any


            #1;



            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Max Data Value Transfer");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 8'hAA;
            dst_addr = 8'h55;
            data_in = 16'hFFFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            fork
                begin
                    wait(done == 1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Alternating Bit Pattern Transfer");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 8'h01;
            dst_addr = 8'hFF;
            data_in = 16'h5A5A;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            fork
                begin
                    wait(done == 1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any

            #1;


            check_outputs(16'h5A5A, 1'b1);
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
        $dumpvars(0,clk, data_in, dst_addr, rst_n, src_addr, start, data_out, done);
    end

endmodule
