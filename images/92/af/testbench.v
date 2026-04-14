`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rf_clock;
    reg [4:0] rf_rd_addr_0;
    reg rf_reset;
    reg [4:0] rf_wr_addr;
    reg [31:0] rf_wr_data;
    reg rf_wr_enable;
    wire [31:0] rf_rd_data_0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rf_clock(rf_clock),
        .rf_rd_addr_0(rf_rd_addr_0),
        .rf_reset(rf_reset),
        .rf_wr_addr(rf_wr_addr),
        .rf_wr_data(rf_wr_data),
        .rf_wr_enable(rf_wr_enable),
        .rf_rd_data_0(rf_rd_data_0)
    );

    // Clock generation (10ns period)
    initial begin
        rf_clock = 0;
        forever #5 rf_clock = ~rf_clock;
    end

        task reset_dut;

        begin
            rf_reset = 1;
            rf_wr_enable = 0;
            rf_wr_addr = 0;
            rf_wr_data = 0;
            rf_rd_addr_0 = 0;
            @(posedge rf_clock);
            #2;
            rf_reset = 0;
            @(posedge rf_clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge rf_clock);
            rf_wr_enable = 1;
            rf_wr_addr = 5'd5;
            rf_wr_data = 32'h12345678;

            @(posedge rf_clock);
            rf_wr_enable = 0;


            rf_rd_addr_0 = 5'd5;
            #5;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();


            rf_rd_addr_0 = 5'd10;
            #5;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Low Check", test_num);
            reset_dut();


            @(posedge rf_clock);
            rf_wr_enable = 0;
            rf_wr_addr = 5'd15;
            rf_wr_data = 32'hCAFEBABE;

            @(posedge rf_clock);


            rf_rd_addr_0 = 5'd15;
            #5;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Address Independence", test_num);
            reset_dut();


            @(posedge rf_clock);
            rf_wr_enable = 1;
            rf_wr_addr = 5'd1;
            rf_wr_data = 32'hAAAA_AAAA;


            @(posedge rf_clock);
            rf_wr_addr = 5'd2;
            rf_wr_data = 32'hBBBB_BBBB;

            @(posedge rf_clock);
            rf_wr_enable = 0;


            rf_rd_addr_0 = 5'd1;
            #5;

            #1;


            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Address and Value", test_num);
            reset_dut();


            @(posedge rf_clock);
            rf_wr_enable = 1;
            rf_wr_addr = 5'd31;
            rf_wr_data = 32'hFFFF_FFFF;

            @(posedge rf_clock);
            rf_wr_enable = 0;

            rf_rd_addr_0 = 5'd31;
            #5;

            #1;


            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Register 0 Access", test_num);
            reset_dut();


            @(posedge rf_clock);
            rf_wr_enable = 1;
            rf_wr_addr = 5'd0;
            rf_wr_data = 32'h5555_6666;

            @(posedge rf_clock);
            rf_wr_enable = 0;

            rf_rd_addr_0 = 5'd0;
            #5;



            #1;




            check_outputs(32'h5555_6666);
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
        input [31:0] expected_rf_rd_data_0;
        begin
            if (expected_rf_rd_data_0 === (expected_rf_rd_data_0 ^ rf_rd_data_0 ^ expected_rf_rd_data_0)) begin
                $display("PASS");
                $display("  Outputs: rf_rd_data_0=%h",
                         rf_rd_data_0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rf_rd_data_0=%h",
                         expected_rf_rd_data_0);
                $display("  Got:      rf_rd_data_0=%h",
                         rf_rd_data_0);
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
        $dumpvars(0,rf_clock, rf_rd_addr_0, rf_reset, rf_wr_addr, rf_wr_data, rf_wr_enable, rf_rd_data_0);
    end

endmodule
