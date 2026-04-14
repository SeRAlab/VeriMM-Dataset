`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dst_addr;
    reg rst;
    reg [7:0] src_addr;
    reg valid_transfer;
    wire ack;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dst_addr(dst_addr),
        .rst(rst),
        .src_addr(src_addr),
        .valid_transfer(valid_transfer),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_transfer = 0;
            data_in = 8'h00;
            src_addr = 8'h00;
            dst_addr = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Basic Data Transfer", test_num);
            reset_dut();


            src_addr = 8'h10;
            dst_addr = 8'h20;
            data_in = 8'hA5;
            valid_transfer = 1;



            @(posedge clk);
            while (!ack) @(posedge clk);


            #1 valid_transfer = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Alternative Data and Address Transfer", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dst_addr = 8'h00;
            data_in = 8'h5A;
            valid_transfer = 1;

            @(posedge clk);
            while (!ack) @(posedge clk);

            #1 valid_transfer = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Idle State Check (No valid signal)", test_num);
            reset_dut();

            src_addr = 8'h11;
            dst_addr = 8'h22;
            data_in = 8'hEE;
            valid_transfer = 0;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Reset and Max Value Transfer", test_num);
            reset_dut();

            src_addr = 8'hFE;
            dst_addr = 8'hFD;
            data_in = 8'hFF;
            valid_transfer = 1;

            @(posedge clk);
            while (!ack) @(posedge clk);

            #1 valid_transfer = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hFF);
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
        input expected_ack;
        input [7:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, dst_addr, rst, src_addr, valid_transfer, ack, data_out);
    end

endmodule
