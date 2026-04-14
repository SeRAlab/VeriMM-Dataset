`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dst_addr1;
    reg [31:0] dst_addr2;
    reg reset;
    reg [31:0] src_addr1;
    reg [31:0] src_addr2;
    reg start;
    wire channel_active;
    wire [31:0] data_transferred;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dst_addr1(dst_addr1),
        .dst_addr2(dst_addr2),
        .reset(reset),
        .src_addr1(src_addr1),
        .src_addr2(src_addr2),
        .start(start),
        .channel_active(channel_active),
        .data_transferred(data_transferred),
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
            src_addr1 = 32'h0;
            dst_addr1 = 32'h0;
            src_addr2 = 32'h0;
            dst_addr2 = 32'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Transfer Cycle", test_num);
            reset_dut();

            src_addr1 = 32'hAAAA_BBBB;
            dst_addr1 = 32'h1111_2222;
            src_addr2 = 32'hCCCC_DDDD;
            dst_addr2 = 32'h3333_4444;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            wait(transfer_done == 1);



            #1;




            check_outputs(1'b1, 32'hCCCC_DDDD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Different Address Inputs", test_num);
            reset_dut();

            src_addr1 = 32'hDEAF_BEEF;
            dst_addr1 = 32'h0000_1111;
            src_addr2 = 32'hFEED_FACE;
            dst_addr2 = 32'h2222_3333;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(transfer_done == 1);


            #1;



            check_outputs(1'b1, 32'hFEED_FACE, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();

            src_addr1 = 32'h1234_5678;
            src_addr2 = 32'h8765_4321;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Operation", test_num);
            reset_dut();

            src_addr1 = 32'h1111_1111;
            src_addr2 = 32'h2222_2222;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(1) @(posedge clk);
            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;


            #1;



            check_outputs(1'b0, 32'h0, 1'b0);
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
        input expected_channel_active;
        input [31:0] expected_data_transferred;
        input expected_transfer_done;
        begin
            if (expected_channel_active === (expected_channel_active ^ channel_active ^ expected_channel_active) &&
                expected_data_transferred === (expected_data_transferred ^ data_transferred ^ expected_data_transferred) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: channel_active=%b, data_transferred=%h, transfer_done=%b",
                         channel_active, data_transferred, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_active=%b, data_transferred=%h, transfer_done=%b",
                         expected_channel_active, expected_data_transferred, expected_transfer_done);
                $display("  Got:      channel_active=%b, data_transferred=%h, transfer_done=%b",
                         channel_active, data_transferred, transfer_done);
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
        $dumpvars(0,clk, dst_addr1, dst_addr2, reset, src_addr1, src_addr2, start, channel_active, data_transferred, transfer_done);
    end

endmodule
