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
            wren = 0;
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            @(negedge clock);
            wren = 1;
            wraddress = 5'd5;
            data = 32'h12345678;


            @(negedge clock);
            wren = 0;
            rdaddress = 5'd5;


            @(negedge clock);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Address Check (31)", test_num);

            @(negedge clock);
            wren = 1;
            wraddress = 5'd31;
            data = 32'hABCDEF01;

            @(negedge clock);
            wren = 0;
            rdaddress = 5'd31;

            @(negedge clock);
            #1;

            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable (wren=0) Check", test_num);


            @(negedge clock);
            wren = 0;
            wraddress = 5'd10;
            data = 32'h55555555;


            @(negedge clock);
            rdaddress = 5'd10;

            @(negedge clock);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Address Isolation Check", test_num);


            @(negedge clock);
            wren = 1; wraddress = 5'd1; data = 32'hAAAA_AAAA;
            @(negedge clock);


            wren = 1; wraddress = 5'd2; data = 32'hBBBB_BBBB;
            @(negedge clock);


            wren = 0; rdaddress = 5'd1;
            @(negedge clock);
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overwrite Data Check", test_num);


            @(negedge clock);
            wren = 1; wraddress = 5'd15; data = 32'h1111_1111;
            @(negedge clock);


            wren = 1; wraddress = 5'd15; data = 32'h2222_2222;
            @(negedge clock);


            wren = 0; rdaddress = 5'd15;
            @(negedge clock);
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Concurrent Read/Write Check", test_num);


            @(negedge clock);
            wren = 1; wraddress = 5'd20; data = 32'hCAFE_BABE;
            @(negedge clock);


            wren = 1; wraddress = 5'd21; data = 32'h9999_8888;
            rdaddress = 5'd20;


            @(negedge clock);
            #1;

            check_outputs(32'hCAFE_BABE);
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
