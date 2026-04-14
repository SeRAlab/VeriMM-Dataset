`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg rst;
    reg rw;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
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
        .rst(rst),
        .rw(rw),
        .src_addr(src_addr),
        .start(start),
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
            src_addr = 8'h00;
            dest_addr = 8'h00;
            data_in = 8'h00;
            rw = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase%03d: Basic Read Operation", test_num);
            reset_dut();

            src_addr = 8'h0A;
            dest_addr = 8'h55;
            data_in = 8'hBC;
            rw = 0;
            start = 1;

            @(posedge clk);
            start = 0;


            repeat (5) begin
                if (!transfer_complete) @(posedge clk);
            end

            #1;


            check_outputs(8'hBC, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase%03d: Basic Write Operation", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'hF0;
            data_in = 8'h33;
            rw = 1;
            start = 1;

            @(posedge clk);
            start = 0;

            repeat (5) begin
                if (!transfer_complete) @(posedge clk);
            end

            #1;


            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase%03d: Idle Check", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            data_in = 8'hFF;
            rw = 0;
            start = 0;

            repeat (3) @(posedge clk);



            #1;




            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase%03d: Consecutive Transfer Check", test_num);
            reset_dut();


            src_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 8'hDE;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(transfer_complete);
            @(posedge clk);


            src_addr = 8'h03;
            dest_addr = 8'h04;
            data_in = 8'hAD;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) begin
                if (!transfer_complete) @(posedge clk);
            end

            #1;


            check_outputs(8'hAD, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase%03d: Zero Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'hFF;
            data_in = 8'h00;
            rw = 1;
            start = 1;

            @(posedge clk);
            start = 0;

            repeat (5) begin
                if (!transfer_complete) @(posedge clk);
            end

            #1;


            check_outputs(8'h00, 1'b1);
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
        $dumpvars(0,clk, data_in, dest_addr, rst, rw, src_addr, start, data_out, transfer_complete);
    end

endmodule
