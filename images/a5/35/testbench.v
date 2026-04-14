`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire [11:0] johnson_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .johnson_out(johnson_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Step Transition");
            reset_dut();
            enable = 1;
            @(negedge clk);
            enable = 0;


            #1;



            check_outputs(12'h800);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: 12-Step Transition (All 1s)");
            reset_dut();
            enable = 1;
            for (i = 0; i < 12; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Full Cycle (24 steps)");
            reset_dut();
            enable = 1;
            for (i = 0; i < 24; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Enable/Disable Toggle Check");
            reset_dut();
            enable = 1;

            for (i = 0; i < 5; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;

            repeat(3) @(negedge clk);

            #1;


            check_outputs(12'hF80);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Synchronous Reset During Operation");
            reset_dut();
            enable = 1;

            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
            end

            rst = 1;
            @(negedge clk);
            rst = 0;
            enable = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Transition past half-way (13 steps)");
            reset_dut();
            enable = 1;


            for (i = 0; i < 13; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;
            #1;

            check_outputs(12'h7FF);
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
        input [11:0] expected_johnson_out;
        begin
            if (expected_johnson_out === (expected_johnson_out ^ johnson_out ^ expected_johnson_out)) begin
                $display("PASS");
                $display("  Outputs: johnson_out=%h",
                         johnson_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: johnson_out=%h",
                         expected_johnson_out);
                $display("  Got:      johnson_out=%h",
                         johnson_out);
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
        $dumpvars(0,clk, enable, rst, johnson_out);
    end

endmodule
