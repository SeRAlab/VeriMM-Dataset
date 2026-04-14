`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] data;
    reg [23:0] rdaddress;
    reg [23:0] wraddress;
    reg wrclock;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wrclock(wrclock),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        wrclock = 0;
        forever #5 wrclock = ~wrclock;
    end

        task reset_dut;

        begin
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            wren = 0;
            @(posedge wrclock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Basic Write/Read", test_num);
            wren = 1;
            wraddress = 24'd0;
            data = 32'h12345678;
            @(posedge wrclock);
            #1;
            wren = 0;
            rdaddress = 24'd0;
            #5;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Boundary Address 2047", test_num);
            wren = 1;
            wraddress = 24'd2047;
            data = 32'hDEADBEEF;
            @(posedge wrclock);
            #1;
            wren = 0;
            rdaddress = 24'd2047;
            #5;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Write Enable Check", test_num);

            wren = 1;
            wraddress = 24'd100;
            data = 32'hAAAA_AAAA;
            @(posedge wrclock);
            #1;

            wren = 0;
            wraddress = 24'd100;
            data = 32'h5555_5555;
            @(posedge wrclock);
            #1;
            rdaddress = 24'd100;
            #5;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Out of Bounds Read", test_num);
            rdaddress = 24'd2048;
            #5;
            #1;

            check_outputs(32'hx);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Overwrite Check", test_num);
            wren = 1;
            wraddress = 24'd512;
            data = 32'h1111_1111;
            @(posedge wrclock);
            #1;
            data = 32'h2222_2222;
            @(posedge wrclock);
            #1;
            wren = 0;
            rdaddress = 24'd512;
            #5;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase %03d: Simultaneous read/write different addrs", test_num);

            wren = 1;
            wraddress = 24'd10;
            data = 32'hC0FFEE00;
            @(posedge wrclock);
            #1;

            rdaddress = 24'd10;
            wraddress = 24'd11;
            data = 32'h87654321;
            wren = 1;
            @(posedge wrclock);
            #1;
            #1;

            check_outputs(32'hC0FFEE00);
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
        input [31:0] expected_q;
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
        $dumpvars(0,data, rdaddress, wraddress, wrclock, wren, q);
    end

endmodule
