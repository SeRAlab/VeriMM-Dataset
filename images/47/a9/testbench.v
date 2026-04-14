`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
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
            en = 0;
            rst = 0;
            @(posedge clk);
            #1;
            rst = 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Check");
            test_num = test_num + 1;
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Increment (00 -> 80)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: 4 Increments (00 -> F0)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: 8 Increments (00 -> FF)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: 12 Increments (00 -> 0F)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            repeat(12) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Full 16-state cycle check (00 -> 00)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Enable Control Check (Hold at C0)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            en = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning Testcase 008: Mid-cycle Reset Check");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
            rst = 1;
            #1;

            check_outputs(8'h00);
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
        testcase008();
        
        
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
        input [7:0] expected_count;
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
