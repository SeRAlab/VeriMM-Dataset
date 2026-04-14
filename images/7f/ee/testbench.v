`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DIVIDER;
    reg RST;
    wire SD_CLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIVIDER(DIVIDER),
        .RST(RST),
        .SD_CLK(SD_CLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            DIVIDER = 0;
            #20;
            RST = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=0, Checking toggle after 1 cycle", test_num);
            reset_dut();
            DIVIDER = 8'd0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=0, Checking toggle after 2 cycles", test_num);
            reset_dut();
            DIVIDER = 8'd0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=1, Checking high state at cycle 1", test_num);
            reset_dut();
            DIVIDER = 8'd1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=1, Checking low state at cycle 3", test_num);
            reset_dut();
            DIVIDER = 8'd1;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=4, Checking first toggle at cycle 5", test_num);
            reset_dut();
            DIVIDER = 8'd4;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=4, Checking second toggle at cycle 10", test_num);
            reset_dut();
            DIVIDER = 8'd4;
            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DIVIDER=255, Checking first toggle at cycle 256", test_num);
            reset_dut();
            DIVIDER = 8'd255;
            repeat(256) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify reset forces SD_CLK to 0", test_num);
            reset_dut();
            DIVIDER = 8'd1;
            @(posedge CLK);
            #1;
            RST = 1;
            #10;
            #1;

            check_outputs(1'b0);
            RST = 0;
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
        input expected_SD_CLK;
        begin
            if (expected_SD_CLK === (expected_SD_CLK ^ SD_CLK ^ expected_SD_CLK)) begin
                $display("PASS");
                $display("  Outputs: SD_CLK=%b",
                         SD_CLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SD_CLK=%b",
                         expected_SD_CLK);
                $display("  Got:      SD_CLK=%b",
                         SD_CLK);
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
        $dumpvars(0,CLK, DIVIDER, RST, SD_CLK);
    end

endmodule
