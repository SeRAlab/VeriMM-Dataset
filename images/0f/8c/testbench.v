`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg rst;
    reg start_transfer;
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
            channel_select = 3'b000;
            start_transfer = 0;
            #20;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Starting transfer on Channel 0", test_num);
            reset_dut();

            channel_select = 3'b000;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;


            wait(transfer_complete == 1'b1);
            #1;

            check_outputs(1'b1);
            #20;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Starting transfer on Channel 7", test_num);
            reset_dut();

            channel_select = 3'b111;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;

            wait(transfer_complete == 1'b1);
            #1;

            check_outputs(1'b1);
            #20;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Starting transfer on Channel 3", test_num);
            reset_dut();

            channel_select = 3'b011;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;

            wait(transfer_complete == 1'b1);
            #1;

            check_outputs(1'b1);
            #20;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during start request", test_num);
            reset_dut();

            rst = 1;
            channel_select = 3'b101;
            start_transfer = 1;
            #50;


            #1;



            check_outputs(1'b0);
            rst = 0;
            start_transfer = 0;
            #20;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential transfers (CH 1 then CH 4)", test_num);
            reset_dut();


            channel_select = 3'b001;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;
            wait(transfer_complete == 1'b1);


            #20;


            channel_select = 3'b100;
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;
            wait(transfer_complete == 1'b1);

            #1;


            check_outputs(1'b1);
            #20;
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
        begin
            if (expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: transfer_complete=%b",
                         transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transfer_complete=%b",
                         expected_transfer_complete);
                $display("  Got:      transfer_complete=%b",
                         transfer_complete);
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
        $dumpvars(0,channel_select, clk, rst, start_transfer, transfer_complete);
    end

endmodule
