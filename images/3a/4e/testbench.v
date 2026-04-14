`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg [7:0] mem_data;
    reg rst;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
    wire dma_busy;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .mem_data(mem_data),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
        .dma_busy(dma_busy),
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
            src_addr = 0;
            dest_addr = 0;
            mem_data = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            mem_data = 8'hAA;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(transfer_complete == 1);
            @(posedge clk);


            #1;



            check_outputs(8'hAA, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Alternate Data Value", test_num);
            reset_dut();

            src_addr = 8'h05;
            dest_addr = 8'hF0;
            mem_data = 8'h55;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h55, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Idle State Post-Reset", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h00, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Data Transfer", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'h00;
            mem_data = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h00, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum Value Transfer", test_num);
            reset_dut();

            src_addr = 8'h80;
            dest_addr = 8'h81;
            mem_data = 8'hFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(transfer_complete == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 0, 1);
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
        input [7:0] expected_data_out;
        input expected_dma_busy;
        input expected_transfer_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_dma_busy === (expected_dma_busy ^ dma_busy ^ expected_dma_busy) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, dma_busy=%b, transfer_complete=%b",
                         data_out, dma_busy, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, dma_busy=%b, transfer_complete=%b",
                         expected_data_out, expected_dma_busy, expected_transfer_complete);
                $display("  Got:      data_out=%h, dma_busy=%b, transfer_complete=%b",
                         data_out, dma_busy, transfer_complete);
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
        $dumpvars(0,clk, dest_addr, mem_data, rst, src_addr, start, data_out, dma_busy, transfer_complete);
    end

endmodule
