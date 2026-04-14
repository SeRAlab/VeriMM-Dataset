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
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(negedge clock);
            wraddress = 5;
            data = 32'h12345678;
            wren = 1;

            @(negedge clock);
            wren = 0;
            rdaddress = 5;


            @(negedge clock);
            $display("Testcase %0d: Basic Write and Read", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(negedge clock);
            wraddress = 10;
            data = 32'hAAAAAAAA;
            wren = 1;


            @(negedge clock);
            wraddress = 10;
            data = 32'hBBBBBBBB;
            wren = 0;

            @(negedge clock);
            rdaddress = 10;

            @(negedge clock);
            $display("Testcase %0d: Write Enable Check", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(negedge clock);
            wraddress = 2;
            data = 32'hFEEDFACE;
            wren = 1;


            @(negedge clock);
            wraddress = 3;
            data = 32'hCAFEBEBE;
            wren = 1;
            rdaddress = 2;

            @(negedge clock);
            $display("Testcase %0d: Simultaneous Access", test_num);
            #1;

            check_outputs(32'hFEEDFACE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clock);
            wraddress = 31;
            data = 32'hFFFFFFFF;
            wren = 1;

            @(negedge clock);
            wren = 0;
            rdaddress = 31;

            @(negedge clock);
            $display("Testcase %0d: Boundary Address 31", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clock);
            wraddress = 0;
            data = 32'h55AA55AA;
            wren = 1;

            @(negedge clock);
            wren = 0;
            rdaddress = 0;

            @(negedge clock);
            $display("Testcase %0d: Address 0 Access", test_num);
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(negedge clock);
            wraddress = 15;
            data = 32'h99887766;
            wren = 1;


            @(negedge clock);
            wraddress = 16;
            data = 32'h11223344;
            wren = 1;

            @(negedge clock);
            wren = 0;
            rdaddress = 15;

            @(negedge clock);

            rdaddress = 16;

            @(negedge clock);
            $display("Testcase %0d: Sequential Read Integrity", test_num);
            #1;

            check_outputs(32'h11223344);
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
