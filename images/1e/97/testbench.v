`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg read_enable;
    reg reset;
    reg [7:0] src_addr;
    reg write_enable;
    wire busy;
    wire [7:0] data_out;
    wire [3:0] transfer_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .read_enable(read_enable),
        .reset(reset),
        .src_addr(src_addr),
        .write_enable(write_enable),
        .busy(busy),
        .data_out(data_out),
        .transfer_count(transfer_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        read_enable = 0;
        write_enable = 0;
        data_in = 8'h0;
        src_addr = 8'h0;
        dest_addr = 8'h0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase 001: Verifying post-reset initial state...");
        reset_dut();

        #1;


        check_outputs(0, 8'h00, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase 002: Single DMA read/write transfer...");
        reset_dut();


        src_addr = 8'h10;
        dest_addr = 8'h20;
        data_in = 8'hA5;
        read_enable = 1;
        write_enable = 1;

        @(posedge clk);

        if (busy) begin
            while (busy) @(posedge clk);
        end else begin
            @(posedge clk);
        end

        read_enable = 0;
        write_enable = 0;


        #1;



        check_outputs(0, 8'hA5, 4'h1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase 003: Multiple sequential transfers...");
        reset_dut();

        for (i = 0; i < 5; i = i + 1) begin
            data_in = 8'hD0 + i;
            read_enable = 1;
            write_enable = 1;
            @(posedge clk);
            while (busy) @(posedge clk);
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
        end


        #1;



        check_outputs(0, 8'hD4, 4'h5);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase 004: Verifying 4-bit transfer counter wrap-around...");
        reset_dut();


        for (i = 0; i < 16; i = i + 1) begin
            data_in = i[7:0];
            read_enable = 1;
            write_enable = 1;
            @(posedge clk);
            while (busy) @(posedge clk);
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
        end


        #1;



        check_outputs(0, 8'h0F, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase 005: Reset during operation...");
        reset_dut();


        data_in = 8'hFF;
        read_enable = 1;
        write_enable = 1;
        @(posedge clk);


        reset = 1;
        @(posedge clk);
        reset = 0;
        read_enable = 0;
        write_enable = 0;
        @(posedge clk);


        #1;



        check_outputs(0, 8'h00, 4'h0);
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
        input [3:0] expected_transfer_count;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_count === (expected_transfer_count ^ transfer_count ^ expected_transfer_count)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, transfer_count=%h",
                         busy, data_out, transfer_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, transfer_count=%h",
                         expected_busy, expected_data_out, expected_transfer_count);
                $display("  Got:      busy=%b, data_out=%h, transfer_count=%h",
                         busy, data_out, transfer_count);
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
        $dumpvars(0,clk, data_in, dest_addr, read_enable, reset, src_addr, write_enable, busy, data_out, transfer_count);
    end

endmodule
