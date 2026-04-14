`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg rst;
    reg transfer_enable;
    wire [1:0] active_channel;
    wire mem_read;
    wire mem_write;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .rst(rst),
        .transfer_enable(transfer_enable),
        .active_channel(active_channel),
        .mem_read(mem_read),
        .mem_write(mem_write),
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
            channel_select = 0;
            transfer_enable = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State Check...");
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            $display("\nRunning Testcase 002: Channel 0 Transfer...");
            reset_dut();


            channel_select = 0;
            transfer_enable = 1;
            @(posedge clk);
            #1;


            timeout = 0;
            while (!transfer_complete && timeout < 100) begin
                @(posedge clk);
                timeout = timeout + 1;
            end



            #1 #1;
 check_outputs(2'b01, mem_read, mem_write, 1'b1);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            $display("\nRunning Testcase 003: Channel 1 Transfer...");
            reset_dut();


            channel_select = 1;
            transfer_enable = 1;
            @(posedge clk);
            #1;


            timeout = 0;
            while (!transfer_complete && timeout < 100) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            #1 #1;
 check_outputs(2'b10, mem_read, mem_write, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Idle State (Enable Low)...");
            reset_dut();

            channel_select = 0;
            transfer_enable = 0;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(2'b00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer timeout;
        begin
            $display("\nRunning Testcase 005: Consecutive Transfers...");
            reset_dut();


            channel_select = 0;
            transfer_enable = 1;
            @(posedge clk);
            #1 transfer_enable = 0;

            timeout = 0;
            while (!transfer_complete && timeout < 50) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            @(posedge clk);
            channel_select = 1;
            transfer_enable = 1;
            @(posedge clk);
            #1 transfer_enable = 0;

            timeout = 0;
            while (!transfer_complete && timeout < 50) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            #1 #1;
 check_outputs(2'b10, mem_read, mem_write, 1'b1);
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
        input [1:0] expected_active_channel;
        input expected_mem_read;
        input expected_mem_write;
        input expected_transfer_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_mem_read === (expected_mem_read ^ mem_read ^ expected_mem_read) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, mem_read=%b, mem_write=%b, transfer_complete=%b",
                         active_channel, mem_read, mem_write, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, mem_read=%b, mem_write=%b, transfer_complete=%b",
                         expected_active_channel, expected_mem_read, expected_mem_write, expected_transfer_complete);
                $display("  Got:      active_channel=%h, mem_read=%b, mem_write=%b, transfer_complete=%b",
                         active_channel, mem_read, mem_write, transfer_complete);
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
        $dumpvars(0,channel_select, clk, rst, transfer_enable, active_channel, mem_read, mem_write, transfer_complete);
    end

endmodule
