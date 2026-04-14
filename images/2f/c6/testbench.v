`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dst_addr;
    reg rst;
    reg sel;
    reg [31:0] src_addr;
    reg start;
    wire [1:0] active_channel;
    wire transfer_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dst_addr(dst_addr),
        .rst(rst),
        .sel(sel),
        .src_addr(src_addr),
        .start(start),
        .active_channel(active_channel),
        .transfer_active(transfer_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sel = 0;
            src_addr = 0;
            dst_addr = 0;
            start = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 0 Start", test_num);
            reset_dut();

            @(posedge clk);
            sel = 0;
            src_addr = 32'hAAAA_BBBB;
            dst_addr = 32'hCCCC_DDDD;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Start", test_num);
            reset_dut();

            @(posedge clk);
            sel = 1;
            src_addr = 32'h1111_2222;
            dst_addr = 32'h3333_4444;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Both Channels Active", test_num);
            reset_dut();


            @(posedge clk);
            sel = 0;
            src_addr = 32'hA0A0_A0A0;
            dst_addr = 32'hB0B0_B0B0;
            start = 1;
            @(posedge clk);


            sel = 1;
            src_addr = 32'hC1C1_C1C1;
            dst_addr = 32'hD1D1_D1D1;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during Transfer", test_num);
            reset_dut();


            @(posedge clk);
            sel = 0;
            src_addr = 32'hDEAD_BEEF;
            dst_addr = 32'hCAFE_BABE;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(2'b00, 1'b0);
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
        input [1:0] expected_active_channel;
        input expected_transfer_active;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_active === (expected_transfer_active ^ transfer_active ^ expected_transfer_active)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, transfer_active=%b",
                         active_channel, transfer_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, transfer_active=%b",
                         expected_active_channel, expected_transfer_active);
                $display("  Got:      active_channel=%h, transfer_active=%b",
                         active_channel, transfer_active);
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
        $dumpvars(0,clk, dst_addr, rst, sel, src_addr, start, active_channel, transfer_active);
    end

endmodule
