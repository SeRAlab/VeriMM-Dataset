`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_enable;
    reg clk;
    reg [7:0] data_in_0;
    reg [7:0] data_in_1;
    reg [7:0] dest_addr_0;
    reg [7:0] dest_addr_1;
    reg reset;
    reg [7:0] src_addr_0;
    reg [7:0] src_addr_1;
    wire transfer_done_0;
    wire transfer_done_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_enable(channel_enable),
        .clk(clk),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .dest_addr_0(dest_addr_0),
        .dest_addr_1(dest_addr_1),
        .reset(reset),
        .src_addr_0(src_addr_0),
        .src_addr_1(src_addr_1),
        .transfer_done_0(transfer_done_0),
        .transfer_done_1(transfer_done_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel_enable = 2'b00;
            data_in_0 = 8'h0;
            data_in_1 = 8'h0;
            dest_addr_0 = 8'h0;
            dest_addr_1 = 8'h0;
            src_addr_0 = 8'h0;
            src_addr_1 = 8'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 0 Single Transfer", test_num);
            reset_dut();


            src_addr_0 = 8'h10;
            dest_addr_0 = 8'h20;
            data_in_0 = 8'hAA;
            channel_enable = 2'b01;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Single Transfer", test_num);
            reset_dut();


            src_addr_1 = 8'h30;
            dest_addr_1 = 8'h40;
            data_in_1 = 8'h55;
            channel_enable = 2'b10;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Both Channels", test_num);
            reset_dut();


            src_addr_0 = 8'h01; dest_addr_0 = 8'h02; data_in_0 = 8'h11;
            src_addr_1 = 8'h0A; dest_addr_1 = 8'h0B; data_in_1 = 8'h22;
            channel_enable = 2'b11;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State (No Enable)", test_num);
            reset_dut();

            channel_enable = 2'b00;
            src_addr_0 = 8'hFF; dest_addr_0 = 8'hEE;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            channel_enable = 2'b11;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_transfer_done_0;
        input expected_transfer_done_1;
        begin
            if (expected_transfer_done_0 === (expected_transfer_done_0 ^ transfer_done_0 ^ expected_transfer_done_0) &&
                expected_transfer_done_1 === (expected_transfer_done_1 ^ transfer_done_1 ^ expected_transfer_done_1)) begin
                $display("PASS");
                $display("  Outputs: transfer_done_0=%b, transfer_done_1=%b",
                         transfer_done_0, transfer_done_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transfer_done_0=%b, transfer_done_1=%b",
                         expected_transfer_done_0, expected_transfer_done_1);
                $display("  Got:      transfer_done_0=%b, transfer_done_1=%b",
                         transfer_done_0, transfer_done_1);
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
        $dumpvars(0,channel_enable, clk, data_in_0, data_in_1, dest_addr_0, dest_addr_1, reset, src_addr_0, src_addr_1, transfer_done_0, transfer_done_1);
    end

endmodule
