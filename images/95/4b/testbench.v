`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] data;
    reg [23:0] rdaddress;
    reg rdclken;
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
        .rdclken(rdclken),
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
            data = 32'h0;
            rdaddress = 24'h0;
            rdclken = 1'b0;
            wraddress = 24'h0;
            wren = 1'b0;
            repeat(2) @(posedge wrclock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Simple Write then Read", test_num);


            @(posedge wrclock);
            wren = 1'b1;
            wraddress = 24'h000010;
            data = 32'hABCDEF01;

            @(posedge wrclock);
            wren = 1'b0;


            rdclken = 1'b1;
            rdaddress = 24'h000010;


            repeat(2) @(posedge wrclock);

            #1;


            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write Enable (wren=0) Verification", test_num);


            @(posedge wrclock);
            wren = 1'b1;
            wraddress = 24'h000020;
            data = 32'h11112222;
            @(posedge wrclock);


            wren = 1'b0;
            data = 32'hDEADBEEF;
            @(posedge wrclock);


            rdclken = 1'b1;
            rdaddress = 24'h000020;
            repeat(2) @(posedge wrclock);


            #1;



            check_outputs(32'h11112222);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Read Clock Enable (rdclken=0) Verification", test_num);


            @(posedge wrclock);
            wren = 1'b1;
            wraddress = 24'h000030;
            data = 32'h5555AAAA;
            @(posedge wrclock);
            wren = 1'b0;


            rdclken = 1'b1;
            rdaddress = 24'h000030;
            repeat(2) @(posedge wrclock);


            rdclken = 1'b0;
            rdaddress = 24'h000000;
            repeat(2) @(posedge wrclock);


            #1;



            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Boundary Address (Max Range) Test", test_num);


            @(posedge wrclock);
            wren = 1'b1;
            wraddress = 24'hFFFFFF;
            data = 32'hFEDCBA98;
            @(posedge wrclock);
            wren = 1'b0;

            rdclken = 1'b1;
            rdaddress = 24'hFFFFFF;
            repeat(2) @(posedge wrclock);

            #1;


            check_outputs(32'hFEDCBA98);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Sequential Address Check", test_num);


            @(posedge wrclock);
            wren = 1'b1;
            wraddress = 24'd100;
            data = 32'h00000100;
            @(posedge wrclock);


            wraddress = 24'd101;
            data = 32'h00000101;
            @(posedge wrclock);
            wren = 1'b0;


            rdclken = 1'b1;
            rdaddress = 24'd100;
            repeat(2) @(posedge wrclock);


            rdaddress = 24'd101;
            repeat(2) @(posedge wrclock);

            #1;


            check_outputs(32'h00000101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Simultaneous Write and Read to different addresses", test_num);


            @(posedge wrclock);
            wren = 1'b1;
            wraddress = 24'd200;
            data = 32'h77777777;
            @(posedge wrclock);


            wraddress = 24'd201;
            data = 32'h88888888;
            rdaddress = 24'd200;
            rdclken = 1'b1;

            repeat(2) @(posedge wrclock);

            #1;


            check_outputs(32'h77777777);
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
        $dumpvars(0,data, rdaddress, rdclken, wraddress, wrclock, wren, q);
    end

endmodule
