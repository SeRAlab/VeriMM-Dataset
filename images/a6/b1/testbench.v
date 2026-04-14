`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CB;
    reg CLOCK_50;
    reg [11:0] D;
    reg ENABLE;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CB(CB),
        .CLOCK_50(CLOCK_50),
        .D(D),
        .ENABLE(ENABLE),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

    begin
        CB = 0;
        D = 12'h000;
        ENABLE = 0;
        @(posedge CLOCK_50);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Loading 12'hA5A (MSB=1)...", test_num);
        CB = 0;
        D = 12'hA5A;
        @(posedge CLOCK_50);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Loading 12'h5A5 (MSB=0)...", test_num);
        CB = 0;
        D = 12'h5A5;
        @(posedge CLOCK_50);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Load 12'h400 and shift left once...", test_num);

        CB = 0;
        D = 12'h400;
        @(posedge CLOCK_50);
        #1;

        CB = 1;
        ENABLE = 1;
        @(posedge CLOCK_50);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Load 12'h001 and shift left 11 times...", test_num);

        CB = 0;
        D = 12'h001;
        @(posedge CLOCK_50);
        #1;

        CB = 1;
        ENABLE = 1;
        for(i = 0; i < 11; i = i + 1) begin
            @(posedge CLOCK_50);
        end
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Verify shift is inhibited when ENABLE=0...", test_num);

        CB = 0;
        D = 12'h800;
        @(posedge CLOCK_50);
        #1;

        CB = 1;
        ENABLE = 0;
        @(posedge CLOCK_50);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Verify CB=0 prioritizes load over shift...", test_num);

        CB = 0;
        D = 12'hFFF;
        @(posedge CLOCK_50);
        #1;

        CB = 0;
        ENABLE = 1;
        D = 12'h000;
        @(posedge CLOCK_50);
        #1;
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
        $display("top_module Testbench");
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
        input expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
        $dumpvars(0,CB, CLOCK_50, D, ENABLE, OUT);
    end

endmodule
