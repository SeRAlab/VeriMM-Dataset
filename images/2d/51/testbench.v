`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire [7:0] data_out;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
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
            rst = 1;
            start = 0;
            data_in = 0;
            addr = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Test Case 001: Basic Transfer...");
            test_num = 1;
            reset_dut();

            addr = 16'h1234;
            data_in = 8'hAB;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork : wait_done_001
                begin
                    repeat(10) @(posedge clk);
                    disable wait_done_001;
                end
                begin
                    wait(transfer_done == 1'b1);
                    disable wait_done_001;
                end
            join


            #1;
            #1;

            check_outputs(8'hAB, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Test Case 002: Different Data Transfer...");
            test_num = 2;
            reset_dut();

            addr = 16'hFFFF;
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            fork : wait_done_002
                begin
                    repeat(10) @(posedge clk);
                    disable wait_done_002;
                end
                begin
                    wait(transfer_done == 1'b1);
                    disable wait_done_002;
                end
            join

            #1;
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Test Case 003: Idle State Verification...");
            test_num = 3;
            reset_dut();

            addr = 16'hAAAA;
            data_in = 8'hEE;
            start = 0;

            repeat(5) @(posedge clk);

            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Test Case 004: Successive Transfers...");
            test_num = 4;
            reset_dut();


            addr = 16'h1111;
            data_in = 8'h11;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(transfer_done == 1'b1);
            @(posedge clk);


            addr = 16'h2222;
            data_in = 8'h22;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            fork : wait_done_004
                begin
                    repeat(10) @(posedge clk);
                    disable wait_done_004;
                end
                begin
                    wait(transfer_done == 1'b1);
                    disable wait_done_004;
                end
            join

            #1;
            #1;

            check_outputs(8'h22, 1'b1);
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
        $dumpvars(0,addr, clk, data_in, rst, start, data_out, transfer_done);
    end

endmodule
