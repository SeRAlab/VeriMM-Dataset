`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg [7:0] data_in;
    reg [7:0] destination_address;
    reg reset;
    reg [7:0] source_address;
    reg start;
    wire [7:0] data_out;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .destination_address(destination_address),
        .reset(reset),
        .source_address(source_address),
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
            reset = 1;
            start = 0;
            channel_select = 0;
            data_in = 8'h00;
            source_address = 8'h00;
            destination_address = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic transfer on Channel 0", test_num);

            source_address = 8'h10;
            destination_address = 8'h20;
            data_in = 8'hA5;
            channel_select = 1'b0;
            start = 1'b1;

            @(posedge clk);
            start = 1'b0;


            while (!transfer_done) @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic transfer on Channel 1", test_num);

            source_address = 8'h30;
            destination_address = 8'h40;
            data_in = 8'h5A;
            channel_select = 1'b1;
            start = 1'b1;

            @(posedge clk);
            start = 1'b0;


            while (!transfer_done) @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max value transfer on Channel 0", test_num);

            source_address = 8'hFF;
            destination_address = 8'hEE;
            data_in = 8'hFF;
            channel_select = 1'b0;
            start = 1'b1;

            @(posedge clk);
            start = 1'b0;

            while (!transfer_done) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero value transfer on Channel 1", test_num);

            source_address = 8'h00;
            destination_address = 8'h01;
            data_in = 8'h00;
            channel_select = 1'b1;
            start = 1'b1;

            @(posedge clk);
            start = 1'b0;

            while (!transfer_done) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit pattern on Channel 0", test_num);

            source_address = 8'hAA;
            destination_address = 8'h55;
            data_in = 8'hAA;
            channel_select = 1'b0;
            start = 1'b1;

            @(posedge clk);
            start = 1'b0;

            while (!transfer_done) @(posedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
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
        $dumpvars(0,channel_select, clk, data_in, destination_address, reset, source_address, start, data_out, transfer_done);
    end

endmodule
