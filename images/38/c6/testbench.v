`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [15:0] dest_addr;
    reg reset;
    reg [15:0] src_addr;
    reg start;
    wire [15:0] data;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .data(data),
        .transfer_complete(transfer_complete)
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
            channel_select = 3'b000;
            src_addr = 16'h0000;
            dest_addr = 16'h0000;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic transfer on Channel 0");
            reset_dut();

            channel_select = 3'b000;
            src_addr = 16'h1000;
            dest_addr = 16'h2000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(transfer_complete == 1'b1);


            @(posedge clk);



            #1;




            check_outputs(16'h1000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Transfer on Channel 7");
            reset_dut();

            channel_select = 3'b111;
            src_addr = 16'hAAAA;
            dest_addr = 16'h5555;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(transfer_complete == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Transfer on Channel 3");
            reset_dut();

            channel_select = 3'b011;
            src_addr = 16'hC0DE;
            dest_addr = 16'hBEEF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(transfer_complete == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(16'hC0DE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Sequential transfers (Channel 1 then Channel 2)");
            reset_dut();


            channel_select = 3'b001;
            src_addr = 16'h0001;
            dest_addr = 16'h0002;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(transfer_complete == 1'b1);


            channel_select = 3'b010;
            src_addr = 16'h0003;
            dest_addr = 16'h0004;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(transfer_complete == 1'b1);

            @(posedge clk);
            #1;

            check_outputs(16'h0003, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset during transfer");
            reset_dut();

            channel_select = 3'b100;
            src_addr = 16'hFFFF;
            dest_addr = 16'h0000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(2) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(16'h0000, 1'b0);
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
        input [15:0] expected_data;
        input expected_transfer_complete;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data=%h, transfer_complete=%b",
                         data, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, transfer_complete=%b",
                         expected_data, expected_transfer_complete);
                $display("  Got:      data=%h, transfer_complete=%b",
                         data, transfer_complete);
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
        $dumpvars(0,channel_select, clk, dest_addr, reset, src_addr, start, data, transfer_complete);
    end

endmodule
