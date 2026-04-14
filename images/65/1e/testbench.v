`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg en;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .d(d),
        .en(en),
        .rst(rst),
        .q(q)
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
            d = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Shift In", test_num);
            reset_dut();
            en = 1;
            d = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift 4-bit Pattern (1011)", test_num);
            reset_dut();
            en = 1;
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(16'h000B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable Signal Check", test_num);
            reset_dut();
            en = 1; d = 1; @(posedge clk);
            en = 0; d = 0; @(posedge clk);
            en = 0; d = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Full 16-bit Fill (0xAAAA)", test_num);
            reset_dut();
            en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                d = 1; @(posedge clk);
                d = 0; @(posedge clk);
            end
            #1 en = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Overflow Check", test_num);
            reset_dut();
            en = 1;
            d = 1; @(posedge clk);
            repeat(15) begin
                d = 0; @(posedge clk);
            end

            d = 0; @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Synchronous Reset During Operation", test_num);
            reset_dut();
            en = 1; d = 1;
            @(posedge clk);
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_16bit Testbench");
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, en, rst, q);
    end

endmodule
