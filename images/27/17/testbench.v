`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [31:0] data_in;
    reg [31:0] dst_address;
    reg reset;
    reg [31:0] src_address;
    reg start;
    wire [31:0] data_out;
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
        .dst_address(dst_address),
        .reset(reset),
        .src_address(src_address),
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
            start = 0;
            channel_select = 3'b000;
            src_address = 32'h0;
            dst_address = 32'h0;
            data_in = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Channel 0 Basic Transfer", test_num);
            reset_dut();

            src_address = 32'hA000_0000;
            dst_address = 32'hB000_0000;
            channel_select = 3'b000;
            data_in = 32'h1234_5678;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Channel 7 Transfer", test_num);
            reset_dut();

            src_address = 32'hC000_0000;
            dst_address = 32'hD000_0000;
            channel_select = 3'b111;
            data_in = 32'hDEAD_BEEF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Transfer Complete Persistence", test_num);
            reset_dut();

            src_address = 32'h1111_2222;
            dst_address = 32'h3333_4444;
            channel_select = 3'b011;
            data_in = 32'hAAAA_BBBB;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'hAAAA_BBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Zero Transfer", test_num);
            reset_dut();

            src_address = 32'h0000_1000;
            dst_address = 32'h0000_2000;
            channel_select = 3'b100;
            data_in = 32'h0000_0000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All Fs Data Transfer", test_num);
            reset_dut();

            src_address = 32'hFFFF_0000;
            dst_address = 32'h0000_FFFF;
            channel_select = 3'b001;
            data_in = 32'hFFFF_FFFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset Logic Verification", test_num);

            reset_dut();
            start = 1;
            data_in = 32'h5555_AAAA;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(32'h0000_0000, 1'b0);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,channel_select, clk, data_in, dst_address, reset, src_address, start, data_out, transfer_complete);
    end

endmodule
