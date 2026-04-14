`timescale 1ns/1ps

module counter12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter12bit dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Initialization");
            reset_dut();

            #1;


            check_outputs(12'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counting 10 cycles with Enable high");
            reset_dut();
            en = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable Gating (Pause counting)");
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            en = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(12'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Counting to Max Value (4095)");
            reset_dut();
            en = 1;
            repeat (4095) @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Wrap-around logic (4095 -> 0)");
            reset_dut();
            en = 1;
            repeat (4096) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Intermittent Enable toggling");
            reset_dut();
            for (i = 0; i < 20; i = i + 1) begin
                en = ~en;
                @(posedge clk);
            end
            #1;




            #1;





            check_outputs(12'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter12bit Testbench");
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
        input [11:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, rst, count);
    end

endmodule
