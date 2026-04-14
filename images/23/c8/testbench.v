`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] source_addr;
    reg start_transfer;
    wire [15:0] data_out;
    wire transfer_complete;

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
        .source_addr(source_addr),
        .start_transfer(start_transfer),
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
            reset = 1;
            start_transfer = 0;
            source_addr = 0;
            dest_addr = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Data Transfer (0xABCD)");
            reset_dut();

            source_addr = 8'h10;
            dest_addr = 8'h20;
            data_in = 16'hABCD;

            @(posedge clk);
            #1 start_transfer = 1;
            @(posedge clk);
            #1 start_transfer = 0;


            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Data Transfer (0x55AA)");
            reset_dut();

            source_addr = 8'hF0;
            dest_addr = 8'h0F;
            data_in = 16'h55AA;

            @(posedge clk);
            #1 start_transfer = 1;
            @(posedge clk);
            #1 start_transfer = 0;

            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h55AA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Zero Data Transfer");
            reset_dut();

            source_addr = 8'hAA;
            dest_addr = 8'hBB;
            data_in = 16'h0000;

            @(posedge clk);
            #1 start_transfer = 1;
            @(posedge clk);
            #1 start_transfer = 0;

            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Maximum Data Transfer (0xFFFF)");
            reset_dut();

            source_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 16'hFFFF;

            @(posedge clk);
            #1 start_transfer = 1;
            @(posedge clk);
            #1 start_transfer = 0;

            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset State Verification");
            reset_dut();


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
        input [15:0] expected_data_out;
        input expected_transfer_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_complete=%b",
                         expected_data_out, expected_transfer_complete);
                $display("  Got:      data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
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
        $dumpvars(0,clk, data_in, dest_addr, reset, source_addr, start_transfer, data_out, transfer_complete);
    end

endmodule
