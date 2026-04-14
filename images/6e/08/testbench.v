`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .data_in(data_in),
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
        @(posedge clk);
        rst = 1;
        data_in = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Synchronous Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift in single bit (1)", test_num);
        reset_dut();
        data_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift pattern 1101", test_num);
        reset_dut();
        data_in = 1; @(posedge clk);
        data_in = 1; @(posedge clk);
        data_in = 0; @(posedge clk);
        data_in = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000D);
    end
        endtask

    task testcase004;

    integer i;
    reg [15:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Test %0d: Full 16-bit shift (0xAAAA)", test_num);
        reset_dut();
        pattern = 16'hAAAA;
        for (i = 15; i >= 0; i = i - 1) begin
            data_in = pattern[i];
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow check (17 bits)", test_num);
        reset_dut();
        data_in = 1;
        repeat(16) @(posedge clk);
        data_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones (0xFFFF)", test_num);
        reset_dut();
        data_in = 1;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-operation reset", test_num);
        reset_dut();
        data_in = 1;
        repeat(8) @(posedge clk);
        @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
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
        $display("shift_register_16bit Testbench");
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
        $dumpvars(0,clk, data_in, rst, q);
    end

endmodule
