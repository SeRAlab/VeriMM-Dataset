`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dst_addr;
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
            start = 1'b0;
            src_addr = 8'h0;
            dst_addr = 8'h0;
            data_in = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic DMA Transfer...");
            reset_dut();
            test_num = 1;


            src_addr = 8'h10;
            dst_addr = 8'hA0;
            data_in = 16'hDEAD;


            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;


            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(16'hDEAD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Transfer with Different Data and Address...");
            reset_dut();
            test_num = 2;

            src_addr = 8'hFF;
            dst_addr = 8'h00;
            data_in = 16'hBEEF;

            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(16'hBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transfer with Zero Data...");
            reset_dut();
            test_num = 3;

            src_addr = 8'h05;
            dst_addr = 8'h06;
            data_in = 16'h0000;

            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Transfer with Maximum Data Value...");
            reset_dut();
            test_num = 4;

            src_addr = 8'h55;
            dst_addr = 8'hAA;
            data_in = 16'hFFFF;

            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Idle State Check...");
            reset_dut();
            test_num = 5;


            #20;
            #1;

            check_outputs(data_out, 1'b0);
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
        $dumpvars(0,clk, data_in, dst_addr, src_addr, start, data_out, done);
    end

endmodule
