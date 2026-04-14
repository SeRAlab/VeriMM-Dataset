`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_sel;
    reg clk;
    reg control;
    reg enable;
    reg rst_n;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_sel(channel_sel),
        .clk(clk),
        .control(control),
        .enable(enable),
        .rst_n(rst_n),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            channel_sel = 3'b000;
            control = 1'b0;
            enable = 1'b0;
            #20;
            rst_n = 1'b1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Channel 0 Read Transfer", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1'b1;
            channel_sel = 3'd0;
            control = 1'b0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Channel 7 Write Transfer", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1'b1;
            channel_sel = 3'd7;
            control = 1'b1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Disabled Controller Check", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1'b0;
            channel_sel = 3'd4;
            control = 1'b1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Channel 3 Read Transfer", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1'b1;
            channel_sel = 3'd3;
            control = 1'b0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            enable = 1'b1;
            channel_sel = 3'd2;
            control = 1'b1;

            @(posedge clk);
            rst_n = 1'b0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0);
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
        $dumpvars(0,channel_sel, clk, control, enable, rst_n, transfer_complete);
    end

endmodule
