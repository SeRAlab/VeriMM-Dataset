`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bytes_to_transfer;
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg rst_n;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
    wire transfer_complete;
    wire transferring;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .bytes_to_transfer(bytes_to_transfer),
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .rst_n(rst_n),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
        .transfer_complete(transfer_complete),
        .transferring(transferring)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start = 0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            data_in = 8'h00;
            bytes_to_transfer = 4'h0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Single byte transfer", test_num);
            reset_dut();


            src_addr = 8'h10;
            dest_addr = 8'h20;
            bytes_to_transfer = 4'h1;
            data_in = 8'hA5;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(transfer_complete == 1);
            @(posedge clk);



            #1;




            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: 4-byte transfer", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'h80;
            bytes_to_transfer = 4'h4;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            for (i = 0; i < 4; i = i + 1) begin
                data_in = 8'h10 + i;
                @(posedge clk);
            end


            wait(transfer_complete == 1);
            @(posedge clk);



            #1;




            check_outputs(8'h13, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Maximum (15-byte) transfer", test_num);
            reset_dut();

            src_addr = 8'h0A;
            dest_addr = 8'h0B;
            bytes_to_transfer = 4'hF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            for (i = 0; i < 15; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
            end

            wait(transfer_complete == 1);
            @(posedge clk);


            #1;



            check_outputs(8'h0E, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Idle state check (No start)", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            bytes_to_transfer = 4'h5;
            data_in = 8'hFF;

            #50;



            #1;




            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset during active transfer", test_num);
            reset_dut();

            bytes_to_transfer = 4'h8;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            data_in = 8'hCC;

            #30;
            rst_n = 0;
            #20;
            rst_n = 1;
            #10;


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
        input expected_transfer_complete;
        input expected_transferring;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete) &&
                expected_transferring === (expected_transferring ^ transferring ^ expected_transferring)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_complete=%b, transferring=%b",
                         data_out, transfer_complete, transferring);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_complete=%b, transferring=%b",
                         expected_data_out, expected_transfer_complete, expected_transferring);
                $display("  Got:      data_out=%h, transfer_complete=%b, transferring=%b",
                         data_out, transfer_complete, transferring);
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
        $dumpvars(0,bytes_to_transfer, clk, data_in, dest_addr, rst_n, src_addr, start, data_out, transfer_complete, transferring);
    end

endmodule
