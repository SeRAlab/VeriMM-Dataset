`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] data;
    reg [4:0] rdaddress;
    reg [4:0] wraddress;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            data = 32'h0;
            wraddress = 5'h0;
            rdaddress = 5'h0;
            wren = 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Basic Write and Read", test_num);
        reset_dut();

        wren = 1; wraddress = 5'd5; data = 32'hDEADBEEF;
        @(posedge clock); #1;

        wren = 0; rdaddress = 5'd5;
        @(posedge clock); #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Boundary Address 0", test_num);
        reset_dut();
        wren = 1; wraddress = 5'd0; data = 32'hCAFEFACE;
        @(posedge clock); #1;
        wren = 0; rdaddress = 5'd0;
        @(posedge clock); #1;
        #1;

        check_outputs(32'hCAFEFACE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Boundary Address 31", test_num);
        reset_dut();
        wren = 1; wraddress = 5'd31; data = 32'hFFFFFFFF;
        @(posedge clock); #1;
        wren = 0; rdaddress = 5'd31;
        @(posedge clock); #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Overwrite Data", test_num);
        reset_dut();

        wren = 1; wraddress = 5'd10; data = 32'hAAAA_AAAA;
        @(posedge clock); #1;

        wren = 1; wraddress = 5'd10; data = 32'h5555_5555;
        @(posedge clock); #1;
        wren = 0; rdaddress = 5'd10;
        @(posedge clock); #1;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Write Enable Disable", test_num);
        reset_dut();

        wren = 1; wraddress = 5'd15; data = 32'h1234_5678;
        @(posedge clock); #1;

        wren = 0; wraddress = 5'd15; data = 32'h0000_0000;
        @(posedge clock); #1;
        rdaddress = 5'd15;
        @(posedge clock); #1;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Simultaneous R/W Different Addr", test_num);
        reset_dut();

        wren = 1; wraddress = 5'd20; data = 32'hBBBB_CCCC;
        @(posedge clock); #1;

        wren = 1; wraddress = 5'd21; data = 32'hDDDD_EEEE;
        rdaddress = 5'd20;
        @(posedge clock); #1;
        #1;

        check_outputs(32'hBBBB_CCCC);
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
        $dumpvars(0,clock, data, rdaddress, wraddress, wren, q);
    end

endmodule
