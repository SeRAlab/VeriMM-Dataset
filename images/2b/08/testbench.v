`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] req;
    reg rst_n;
    wire [7:0] ack;
    wire busy;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst_n(rst_n),
        .ack(ack),
        .busy(busy),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Idle State Check");
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Channel Request (Ch 0)");
            reset_dut();
            req = 8'h01;


            wait(ack[0] == 1'b1);

            wait(transfer_complete == 1'b1);


            @(posedge clk);
            req = 8'h00;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Single Channel Request (Ch 7)");
            reset_dut();
            req = 8'h80;

            wait(ack[7] == 1'b1);
            wait(transfer_complete == 1'b1);

            @(posedge clk);
            req = 8'h00;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Sequential Round Robin (Ch 0, 1)");
            reset_dut();
            req = 8'h03;


            wait(ack[0] == 1'b1);
            wait(transfer_complete == 1'b1);


            wait(ack[1] == 1'b1);
            wait(transfer_complete == 1'b1);

            @(posedge clk);
            req = 8'h00;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Round Robin Wrap Around (Ch 7 -> Ch 0)");
            reset_dut();


            req = 8'h80;
            wait(ack[7] == 1'b1);
            wait(transfer_complete == 1'b1);


            @(posedge clk);
            req = 8'h81;


            wait(ack[0] == 1'b1);
            wait(transfer_complete == 1'b1);

            wait(ack[7] == 1'b1);
            wait(transfer_complete == 1'b1);

            @(posedge clk);
            req = 8'h00;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase 006: All Channels Simultaneous Request");
            reset_dut();
            req = 8'hFF;

            for (i = 0; i < 8; i = i + 1) begin
                wait(busy == 1'b1);
                wait(transfer_complete == 1'b1);
                @(posedge clk);
            end

            req = 8'h00;
            @(posedge clk);
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
        testcase006();
        
        
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
        input [7:0] expected_ack;
        input expected_busy;
        input expected_transfer_complete;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, busy=%b, transfer_complete=%b",
                         ack, busy, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, busy=%b, transfer_complete=%b",
                         expected_ack, expected_busy, expected_transfer_complete);
                $display("  Got:      ack=%h, busy=%b, transfer_complete=%b",
                         ack, busy, transfer_complete);
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
        $dumpvars(0,clk, req, rst_n, ack, busy, transfer_complete);
    end

endmodule
