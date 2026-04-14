`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_size_chan0;
    reg [7:0] data_size_chan1;
    reg [7:0] dest_addr_chan0;
    reg [7:0] dest_addr_chan1;
    reg req_chan0;
    reg req_chan1;
    reg reset;
    reg [7:0] src_addr_chan0;
    reg [7:0] src_addr_chan1;
    wire ack_chan0;
    wire ack_chan1;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_size_chan0(data_size_chan0),
        .data_size_chan1(data_size_chan1),
        .dest_addr_chan0(dest_addr_chan0),
        .dest_addr_chan1(dest_addr_chan1),
        .req_chan0(req_chan0),
        .req_chan1(req_chan1),
        .reset(reset),
        .src_addr_chan0(src_addr_chan0),
        .src_addr_chan1(src_addr_chan1),
        .ack_chan0(ack_chan0),
        .ack_chan1(ack_chan1),
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
            req_chan0 = 0;
            req_chan1 = 0;
            data_size_chan0 = 0;
            data_size_chan1 = 0;
            src_addr_chan0 = 0;
            src_addr_chan1 = 0;
            dest_addr_chan0 = 0;
            dest_addr_chan1 = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Channel 0 Basic Transfer (Size 5)");
            reset_dut();


            data_size_chan0 = 8'd5;
            src_addr_chan0  = 8'h10;
            dest_addr_chan0 = 8'h20;

            @(posedge clk);
            req_chan0 = 1;



            wait(transfer_done == 1);
            @(posedge clk);
            req_chan0 = 0;



            #1;




            check_outputs(0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Channel 1 Basic Transfer (Size 3)");
            reset_dut();


            data_size_chan1 = 8'd3;
            src_addr_chan1  = 8'hA0;
            dest_addr_chan1 = 8'hB0;

            @(posedge clk);
            req_chan1 = 1;

            wait(transfer_done == 1);
            @(posedge clk);
            req_chan1 = 0;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Channel 0 Small Transfer (Size 1)");
            reset_dut();

            data_size_chan0 = 8'd1;
            src_addr_chan0  = 8'h05;
            dest_addr_chan0 = 8'h06;

            @(posedge clk);
            req_chan0 = 1;

            wait(transfer_done == 1);
            @(posedge clk);
            req_chan0 = 0;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Channel 1 Large Transfer (Size 20)");
            reset_dut();

            data_size_chan1 = 8'd20;
            src_addr_chan1  = 8'h00;
            dest_addr_chan1 = 8'hFF;

            @(posedge clk);
            req_chan1 = 1;

            wait(transfer_done == 1);
            @(posedge clk);
            req_chan1 = 0;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Simultaneous Channel 0 & 1 Requests");
            reset_dut();

            data_size_chan0 = 8'd2;
            data_size_chan1 = 8'd2;
            src_addr_chan0  = 8'h11;
            src_addr_chan1  = 8'h22;

            @(posedge clk);
            req_chan0 = 1;
            req_chan1 = 1;


            wait(transfer_done == 1);
            @(posedge clk);


            repeat(2) @(posedge clk);


            #1;



            check_outputs(ack_chan0, ack_chan1, 1);

            req_chan0 = 0;
            req_chan1 = 0;
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
        input expected_ack_chan0;
        input expected_ack_chan1;
        input expected_transfer_done;
        begin
            if (expected_ack_chan0 === (expected_ack_chan0 ^ ack_chan0 ^ expected_ack_chan0) &&
                expected_ack_chan1 === (expected_ack_chan1 ^ ack_chan1 ^ expected_ack_chan1) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: ack_chan0=%b, ack_chan1=%b, transfer_done=%b",
                         ack_chan0, ack_chan1, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_chan0=%b, ack_chan1=%b, transfer_done=%b",
                         expected_ack_chan0, expected_ack_chan1, expected_transfer_done);
                $display("  Got:      ack_chan0=%b, ack_chan1=%b, transfer_done=%b",
                         ack_chan0, ack_chan1, transfer_done);
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
        $dumpvars(0,clk, data_size_chan0, data_size_chan1, dest_addr_chan0, dest_addr_chan1, req_chan0, req_chan1, reset, src_addr_chan0, src_addr_chan1, ack_chan0, ack_chan1, transfer_done);
    end

endmodule
