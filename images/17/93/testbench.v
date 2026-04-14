`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dest_addr;
    reg [7:0] num_words;
    reg rst;
    reg [31:0] src_addr;
    reg start;
    wire addr_out_valid;
    wire [31:0] data_out;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .num_words(num_words),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .addr_out_valid(addr_out_valid),
        .data_out(data_out),
        .transfer_complete(transfer_complete)
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
            src_addr = 32'h0;
            dest_addr = 32'h0;
            num_words = 8'h0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %0d: Standard Burst Transfer (5 words)", test_num);
            reset_dut();

            src_addr = 32'h1000_0000;
            dest_addr = 32'h2000_0000;
            num_words = 8'd5;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            while (!transfer_complete) begin
                @(posedge clk);
            end



            #1;




            check_outputs(1'b0, data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %0d: Minimum Burst Transfer (1 word)", test_num);
            reset_dut();

            src_addr = 32'hAAAA_0000;
            dest_addr = 32'hBBBB_0000;
            num_words = 8'd1;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!transfer_complete) begin
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0, data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %0d: Large Burst Transfer (16 words)", test_num);
            reset_dut();

            src_addr = 32'hC000_1234;
            dest_addr = 32'hD000_5678;
            num_words = 8'd16;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!transfer_complete) begin
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0, data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %0d: Consecutive Transfers", test_num);
            reset_dut();


            src_addr = 32'h0000_1000;
            dest_addr = 32'h0000_2000;
            num_words = 8'd2;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(transfer_complete);
            @(posedge clk);


            src_addr = 32'h0000_3000;
            dest_addr = 32'h0000_4000;
            num_words = 8'd3;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!transfer_complete) begin
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0, data_out, 1'b1);
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
        input expected_addr_out_valid;
        input [31:0] expected_data_out;
        input expected_transfer_complete;
        begin
            if (expected_addr_out_valid === (expected_addr_out_valid ^ addr_out_valid ^ expected_addr_out_valid) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: addr_out_valid=%b, data_out=%h, transfer_complete=%b",
                         addr_out_valid, data_out, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out_valid=%b, data_out=%h, transfer_complete=%b",
                         expected_addr_out_valid, expected_data_out, expected_transfer_complete);
                $display("  Got:      addr_out_valid=%b, data_out=%h, transfer_complete=%b",
                         addr_out_valid, data_out, transfer_complete);
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
        $dumpvars(0,clk, dest_addr, num_words, rst, src_addr, start, addr_out_valid, data_out, transfer_complete);
    end

endmodule
