`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg rst;
    reg start_transfer;
    wire [7:0] destination_address;
    wire [7:0] source_address;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .rst(rst),
        .start_transfer(start_transfer),
        .destination_address(destination_address),
        .source_address(source_address),
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
            start_transfer = 0;
            channel_select = 2'b00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Channel 0 Transfer", test_num);
            reset_dut();

            channel_select = 2'b00;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;


            repeat (20) begin
                if (transfer_complete) break;
                @(posedge clk);
            end



            #1;




            check_outputs(8'h20, 8'h10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Channel 1 Transfer", test_num);
            reset_dut();

            channel_select = 2'b01;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;


            repeat (20) begin
                if (transfer_complete) break;
                @(posedge clk);
            end


            #1;



            check_outputs(8'h40, 8'h30, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();

            channel_select = 2'b00;
            start_transfer = 0;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(destination_address, source_address, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Reset During Operation", test_num);
            reset_dut();

            channel_select = 2'b01;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;


            repeat(2) @(posedge clk);
            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;


            #1;



            check_outputs(8'h00, 8'h00, 1'b0);
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
        input [7:0] expected_destination_address;
        input [7:0] expected_source_address;
        input expected_transfer_complete;
        begin
            if (expected_destination_address === (expected_destination_address ^ destination_address ^ expected_destination_address) &&
                expected_source_address === (expected_source_address ^ source_address ^ expected_source_address) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: destination_address=%h, source_address=%h, transfer_complete=%b",
                         destination_address, source_address, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: destination_address=%h, source_address=%h, transfer_complete=%b",
                         expected_destination_address, expected_source_address, expected_transfer_complete);
                $display("  Got:      destination_address=%h, source_address=%h, transfer_complete=%b",
                         destination_address, source_address, transfer_complete);
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
        $dumpvars(0,channel_select, clk, rst, start_transfer, destination_address, source_address, transfer_complete);
    end

endmodule
