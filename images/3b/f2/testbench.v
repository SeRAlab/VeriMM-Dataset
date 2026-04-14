`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [31:0] mem_address;
    reg rw;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .mem_address(mem_address),
        .rw(rw),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            channel_select = 3'b000;
            mem_address = 32'h0;
            rw = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Channel 0 Write...");
            reset_dut();
            channel_select = 3'd0;
            mem_address = 32'h1000_0000;
            rw = 1'b0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Channel 7 Read...");
            reset_dut();
            channel_select = 3'd7;
            mem_address = 32'h2000_0000;
            rw = 1'b1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Channel 3 High Address...");
            reset_dut();
            channel_select = 3'd3;
            mem_address = 32'hFFFF_FFFC;
            rw = 1'b0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Channel 1 Read...");
            reset_dut();
            channel_select = 3'd1;
            mem_address = 32'h0000_CAFE;
            rw = 1'b1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Channel 5 Zero Address...");
            reset_dut();
            channel_select = 3'd5;
            mem_address = 32'h0000_0000;
            rw = 1'b0;
            repeat(10) @(posedge clk);
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
        input expected_busy;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: busy=%b",
                         busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b",
                         expected_busy);
                $display("  Got:      busy=%b",
                         busy);
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
        $dumpvars(0,channel_select, clk, mem_address, rw, busy);
    end

endmodule
