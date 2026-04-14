`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire busy;
    wire [7:0] data_out;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .busy(busy),
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
            start = 0;
            channel_select = 0;
            src_addr = 0;
            dest_addr = 0;
            data_in = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 0 Basic Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            src_addr = 8'h10;
            dest_addr = 8'h20;
            data_in = 8'hAA;
            start = 1;

            @(posedge clk);
            start = 0;



            wait(busy == 1);
            wait(transfer_complete == 1);


            #1;
            #1;

            check_outputs(busy, 8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 1 Basic Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 1;
            src_addr = 8'h30;
            dest_addr = 8'h40;
            data_in = 8'h55;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(transfer_complete == 1);

            #1;
            #1;

            check_outputs(busy, 8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 0 with 0xFF Data", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            src_addr = 8'hA1;
            dest_addr = 8'hB2;
            data_in = 8'hFF;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(transfer_complete == 1);

            #1;
            #1;

            check_outputs(busy, 8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 1 with 0x00 Data", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 1;
            src_addr = 8'h00;
            dest_addr = 8'hFF;
            data_in = 8'h00;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(transfer_complete == 1);

            #1;
            #1;

            check_outputs(busy, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Post-transfer stability check", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            src_addr = 8'hDE;
            dest_addr = 8'hAD;
            data_in = 8'hBE;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(transfer_complete == 1);


            repeat(5) @(posedge clk);

            #1;


            if (data_out === 8'hBE) begin
                $display("PASS: Data out stable at 0xBE");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Data out changed after transfer");
                fail_count = fail_count + 1;
            end
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
        input expected_transfer_complete;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, transfer_complete=%b",
                         busy, data_out, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, transfer_complete=%b",
                         expected_busy, expected_data_out, expected_transfer_complete);
                $display("  Got:      busy=%b, data_out=%h, transfer_complete=%b",
                         busy, data_out, transfer_complete);
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
        $dumpvars(0,channel_select, clk, data_in, dest_addr, reset, src_addr, start, busy, data_out, transfer_complete);
    end

endmodule
