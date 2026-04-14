`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg channel1;
    reg channel2;
    reg clk;
    reg reset;
    reg start_transfer;
    wire [7:0] data_out;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr1(addr1),
        .addr2(addr2),
        .channel1(channel1),
        .channel2(channel2),
        .clk(clk),
        .reset(reset),
        .start_transfer(start_transfer),
        .data_out(data_out),
        .transfer_done(transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            addr1 = 8'h0;
            addr2 = 8'h0;
            channel1 = 0;
            channel2 = 0;
            start_transfer = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Channel 1 Single Transfer");
            reset_dut();
            addr1 = 8'hAA;
            channel1 = 1;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;


            wait(transfer_done == 1);
            @(posedge clk);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Channel 2 Single Transfer");
            reset_dut();
            addr2 = 8'hBB;
            channel2 = 1;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;

            wait(transfer_done == 1);
            @(posedge clk);
            #1;

            check_outputs(8'hBB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Both Ready - RR Priority Channel 1");
            reset_dut();
            addr1 = 8'h11;
            addr2 = 8'h22;
            channel1 = 1;
            channel2 = 1;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;

            wait(transfer_done == 1);
            @(posedge clk);
            #1;

            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Both Ready - RR Rotation to Channel 2");
            reset_dut();
            addr1 = 8'h11;
            addr2 = 8'h22;
            channel1 = 1;
            channel2 = 1;


            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;
            wait(transfer_done == 1);
            @(posedge clk);


            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;
            wait(transfer_done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: No channels ready");
            reset_dut();
            channel1 = 0;
            channel2 = 0;
            @(posedge clk);
            start_transfer = 1;
            repeat(10) @(posedge clk);
            start_transfer = 0;


            #1;



            check_outputs(data_out, 1'b0);
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
        input expected_transfer_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_done=%b",
                         data_out, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_done=%b",
                         expected_data_out, expected_transfer_done);
                $display("  Got:      data_out=%h, transfer_done=%b",
                         data_out, transfer_done);
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
        $dumpvars(0,addr1, addr2, channel1, channel2, clk, reset, start_transfer, data_out, transfer_done);
    end

endmodule
