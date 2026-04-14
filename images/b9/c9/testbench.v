`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg FPGA_CLK;
    reg FPGA_MOSI;
    reg MK_CLK;
    reg MK_MOSI;
    reg SWITCH;
    reg WIZ_MISO;
    wire FPGA_MISO;
    wire MK_MISO;
    wire WIZ_CLK;
    wire WIZ_MOSI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FPGA_CLK(FPGA_CLK),
        .FPGA_MOSI(FPGA_MOSI),
        .MK_CLK(MK_CLK),
        .MK_MOSI(MK_MOSI),
        .SWITCH(SWITCH),
        .WIZ_MISO(WIZ_MISO),
        .FPGA_MISO(FPGA_MISO),
        .MK_MISO(MK_MISO),
        .WIZ_CLK(WIZ_CLK),
        .WIZ_MOSI(WIZ_MOSI)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: SWITCH=1 - Route MK signals to WIZ", test_num);

            SWITCH = 1;
            MK_CLK = 1;
            MK_MOSI = 1;
            WIZ_MISO = 1;
            FPGA_CLK = 0;
            FPGA_MOSI = 0;

            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: SWITCH=1 - Route MK signals to WIZ (different data)", test_num);

            SWITCH = 1;
            MK_CLK = 0;
            MK_MOSI = 0;
            WIZ_MISO = 0;
            FPGA_CLK = 1;
            FPGA_MOSI = 1;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: SWITCH=0 - Route FPGA signals to WIZ", test_num);

            SWITCH = 0;
            FPGA_CLK = 1;
            FPGA_MOSI = 1;
            WIZ_MISO = 1;
            MK_CLK = 0;
            MK_MOSI = 0;

            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: SWITCH=0 - Route FPGA signals to WIZ (different data)", test_num);

            SWITCH = 0;
            FPGA_CLK = 0;
            FPGA_MOSI = 0;
            WIZ_MISO = 0;
            MK_CLK = 1;
            MK_MOSI = 1;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verify FPGA inputs don't affect outputs when SWITCH=1", test_num);

            SWITCH = 1;
            MK_CLK = 1;
            MK_MOSI = 1;
            WIZ_MISO = 1;

            FPGA_CLK = 1;
            FPGA_MOSI = 1;
            #5;
            FPGA_CLK = 0;
            FPGA_MOSI = 0;

            #5;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Verify MK inputs don't affect outputs when SWITCH=0", test_num);

            SWITCH = 0;
            FPGA_CLK = 1;
            FPGA_MOSI = 1;
            WIZ_MISO = 1;

            MK_CLK = 1;
            MK_MOSI = 1;
            #5;
            MK_CLK = 0;
            MK_MOSI = 0;

            #5;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
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
        input expected_FPGA_MISO;
        input expected_MK_MISO;
        input expected_WIZ_CLK;
        input expected_WIZ_MOSI;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FPGA_MISO === (expected_FPGA_MISO ^ FPGA_MISO ^ expected_FPGA_MISO) &&
                expected_MK_MISO === (expected_MK_MISO ^ MK_MISO ^ expected_MK_MISO) &&
                expected_WIZ_CLK === (expected_WIZ_CLK ^ WIZ_CLK ^ expected_WIZ_CLK) &&
                expected_WIZ_MOSI === (expected_WIZ_MOSI ^ WIZ_MOSI ^ expected_WIZ_MOSI)) begin
                $display("PASS");
                $display("  Outputs: FPGA_MISO=%b, MK_MISO=%b, WIZ_CLK=%b, WIZ_MOSI=%b",
                         FPGA_MISO, MK_MISO, WIZ_CLK, WIZ_MOSI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FPGA_MISO=%b, MK_MISO=%b, WIZ_CLK=%b, WIZ_MOSI=%b",
                         expected_FPGA_MISO, expected_MK_MISO, expected_WIZ_CLK, expected_WIZ_MOSI);
                $display("  Got:      FPGA_MISO=%b, MK_MISO=%b, WIZ_CLK=%b, WIZ_MOSI=%b",
                         FPGA_MISO, MK_MISO, WIZ_CLK, WIZ_MOSI);
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

endmodule
