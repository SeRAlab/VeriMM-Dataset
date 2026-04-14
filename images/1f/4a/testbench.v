`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
    wire read_enable;
    wire write_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
        .read_enable(read_enable),
        .write_enable(write_enable)
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
            src_addr = 8'h00;
            dest_addr = 8'h00;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic DMA Operation", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during Operation", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            @(posedge clk);
            start = 1;
            @(posedge clk);


            repeat(1) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
            reset = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Transfers", test_num);
            reset_dut();


            src_addr = 8'h01;
            dest_addr = 8'h02;
            start = 1; @(posedge clk); start = 0;
            repeat(10) @(posedge clk);


            src_addr = 8'hF0;
            dest_addr = 8'h0F;
            start = 1; @(posedge clk); start = 0;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start pulse duration test", test_num);
            reset_dut();

            src_addr = 8'hCC;
            dest_addr = 8'hDD;


            start = 1;
            repeat(5) @(posedge clk);
            start = 0;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
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
        input expected_read_enable;
        input expected_write_enable;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_read_enable === (expected_read_enable ^ read_enable ^ expected_read_enable) &&
                expected_write_enable === (expected_write_enable ^ write_enable ^ expected_write_enable)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, read_enable=%b, write_enable=%b",
                         data_out, read_enable, write_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, read_enable=%b, write_enable=%b",
                         expected_data_out, expected_read_enable, expected_write_enable);
                $display("  Got:      data_out=%h, read_enable=%b, write_enable=%b",
                         data_out, read_enable, write_enable);
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
        $dumpvars(0,clk, dest_addr, reset, src_addr, start, data_out, read_enable, write_enable);
    end

endmodule
