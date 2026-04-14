`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg reset;
    reg start;
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
        .reset(reset),
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
            reset = 1;
            channel_select = 2'b00;
            start = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Channel 0 Transfer");
            test_num = test_num + 1;
            reset_dut();

            channel_select = 2'b00;
            start = 1;
            @(posedge clk);
            start = 0;



            fork
                begin : wait_done
                    wait(transfer_complete == 1'b1);
                end
                begin : timeout_guard
                    repeat (100) @(posedge clk);
                end
            join_any
            disable wait_done;



            #1;




            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Channel 1 Transfer");
            test_num = test_num + 1;
            reset_dut();

            channel_select = 2'b01;
            start = 1;
            @(posedge clk);
            start = 0;

            fork
                begin : wait_done
                    wait(transfer_complete == 1'b1);
                end
                begin : timeout_guard
                    repeat (100) @(posedge clk);
                end
            join_any
            disable wait_done;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Sequential Channel Transfers (0 then 1)");
            test_num = test_num + 1;
            reset_dut();


            channel_select = 2'b00;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(transfer_complete == 1'b1);
            @(posedge clk);


            channel_select = 2'b01;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(transfer_complete == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Idle State Verification");
            test_num = test_num + 1;
            reset_dut();

            channel_select = 2'b00;
            start = 0;
            repeat (10) @(posedge clk);


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset during transfer");
            test_num = test_num + 1;
            reset_dut();

            channel_select = 2'b01;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (2) @(posedge clk);
            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;


            #1;



            check_outputs(8'h00, 1'b0);
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
        $dumpvars(0,channel_select, clk, reset, start, data_out, transfer_complete);
    end

endmodule
