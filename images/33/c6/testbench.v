`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg [1:0] channel;
    reg clk;
    reg [7:0] read_data;
    reg rst;
    reg start;
    wire transfer_complete;
    wire [7:0] write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack(ack),
        .channel(channel),
        .clk(clk),
        .read_data(read_data),
        .rst(rst),
        .start(start),
        .transfer_complete(transfer_complete),
        .write_data(write_data)
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
            channel = 2'b00;
            read_data = 8'h00;
            ack = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Channel 0 transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel = 2'b00;
            read_data = 8'hAA;
            start = 1;

            @(posedge clk);
            start = 0;


            #20;
            ack = 1;
            @(posedge clk);
            ack = 0;


            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Channel 1 transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel = 2'b01;
            read_data = 8'h55;
            start = 1;

            @(posedge clk);
            start = 0;

            #20;
            ack = 1;
            @(posedge clk);
            ack = 0;

            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing Channel 2 transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel = 2'b10;
            read_data = 8'hFF;
            start = 1;

            @(posedge clk);
            start = 0;

            #20;
            ack = 1;
            @(posedge clk);
            ack = 0;

            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing Channel 3 transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel = 2'b11;
            read_data = 8'h12;
            start = 1;

            @(posedge clk);
            start = 0;

            #20;
            ack = 1;
            @(posedge clk);
            ack = 0;

            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Sequential Channel transfers (0 then 1)", test_num);
            reset_dut();


            @(posedge clk);
            channel = 2'b00;
            read_data = 8'h11;
            start = 1;
            @(posedge clk);
            start = 0;
            #10 ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            @(posedge clk);
            channel = 2'b01;
            read_data = 8'h22;
            start = 1;
            @(posedge clk);
            start = 0;
            #10 ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h22);
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
        input expected_transfer_complete;
        input [7:0] expected_write_data;
        begin
            if (expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete) &&
                expected_write_data === (expected_write_data ^ write_data ^ expected_write_data)) begin
                $display("PASS");
                $display("  Outputs: transfer_complete=%b, write_data=%h",
                         transfer_complete, write_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transfer_complete=%b, write_data=%h",
                         expected_transfer_complete, expected_write_data);
                $display("  Got:      transfer_complete=%b, write_data=%h",
                         transfer_complete, write_data);
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
        $dumpvars(0,ack, channel, clk, read_data, rst, start, transfer_complete, write_data);
    end

endmodule
