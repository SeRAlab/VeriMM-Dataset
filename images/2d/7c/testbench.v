`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg rst;
    reg [7:0] src_addr;
    reg start;
    reg [7:0] transfer_size;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .transfer_size(transfer_size),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            src_addr = 0;
            dest_addr = 0;
            transfer_size = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Basic transfer (Size 10)");
            reset_dut();
            src_addr = 8'h10;
            dest_addr = 8'h50;
            transfer_size = 8'd10;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (done === 1'b0) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Minimum transfer (Size 1)");
            reset_dut();
            src_addr = 8'h01;
            dest_addr = 8'h02;
            transfer_size = 8'd1;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 1'b0) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Large transfer (Size 50)");
            reset_dut();
            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            transfer_size = 8'd50;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 1'b0) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Maximum transfer (Size 255)");
            reset_dut();
            src_addr = 8'h00;
            dest_addr = 8'hFF;
            transfer_size = 8'd255;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 1'b0) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Idle check (Ensure 'done' is low without start)");
            reset_dut();
            src_addr = 8'h11;
            dest_addr = 8'h22;
            transfer_size = 8'd10;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        input expected_done;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%b",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b",
                         expected_done);
                $display("  Got:      done=%b",
                         done);
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
        $dumpvars(0,clk, dest_addr, rst, src_addr, start, transfer_size, done);
    end

endmodule
