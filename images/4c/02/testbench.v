`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [3:0] johnson;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .johnson(johnson)
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
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset Check");
            reset_dut();
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Advance 4 cycles (All 1s)");
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full Cycle (8 cycles)");
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Signal Hold Check");
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            en = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 6 cycles check");
            reset_dut();
            en = 1;
            repeat(6) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Wrap-around + 1 cycle");
            reset_dut();
            en = 1;
            repeat(9) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Intermittent Enable");
            reset_dut();
            @(posedge clk) en = 1;
            @(posedge clk) en = 0;
            @(posedge clk);
            @(posedge clk) en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_johnson;
        begin
            if (expected_johnson === (expected_johnson ^ johnson ^ expected_johnson)) begin
                $display("PASS");
                $display("  Outputs: johnson=%h",
                         johnson);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: johnson=%h",
                         expected_johnson);
                $display("  Got:      johnson=%h",
                         johnson);
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
        $dumpvars(0,clk, en, rst, johnson);
    end

endmodule
