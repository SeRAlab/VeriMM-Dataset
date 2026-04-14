`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [71:0] data;
    reg [9:0] rdaddress;
    reg rden;
    reg [9:0] wraddress;
    reg wren;
    wire [71:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .rden(rden),
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
            rden = 0;
            wraddress = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clock);
            wren = 1;
            wraddress = 10'h000;
            data = 72'hAAAA_BBBB_CCCC_DDDD_E;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rden = 1;
            rdaddress = 10'h000;
            @(posedge clock);
            #1;

            #1;


            check_outputs(72'hAAAA_BBBB_CCCC_DDDD_E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read with rden=0", test_num);
            reset_dut();


            @(posedge clock);
            wren = 1;
            wraddress = 10'h010;
            data = 72'h1234_5678_9ABC_DEF0_1;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rden = 0;
            rdaddress = 10'h010;
            @(posedge clock);
            #1;

            #1;


            check_outputs(72'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address (1023)", test_num);
            reset_dut();


            @(posedge clock);
            wren = 1;
            wraddress = 10'h3FF;
            data = 72'hFFFF_FFFF_FFFF_FFFF_F;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rden = 1;
            rdaddress = 10'h3FF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(72'hFFFF_FFFF_FFFF_FFFF_F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite data", test_num);
            reset_dut();


            @(posedge clock);
            wren = 1;
            wraddress = 10'h050;
            data = 72'h1111_1111_1111_1111_1;
            @(posedge clock);


            wraddress = 10'h050;
            data = 72'h2222_2222_2222_2222_2;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rden = 1;
            rdaddress = 10'h050;
            @(posedge clock);
            #1;

            #1;


            check_outputs(72'h2222_2222_2222_2222_2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clock);
            wren = 1;
            wraddress = 10'h0A0;
            data = 72'hDEAD_BEEF_CAFE_BABE_1;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            wren = 1;
            wraddress = 10'h0B0;
            data = 72'h5555_5555_5555_5555_5;
            rden = 1;
            rdaddress = 10'h0A0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(72'hDEAD_BEEF_CAFE_BABE_1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous Read", test_num);
            reset_dut();

            @(posedge clock);
            wren = 1;
            wraddress = 10'h077;
            data = 72'h9999_8888_7777_6666_5;
            @(posedge clock);
            wren = 0;

            @(posedge clock);
            rden = 1;
            rdaddress = 10'h077;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(72'h9999_8888_7777_6666_5);
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
        input [71:0] expected_q;
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
        $dumpvars(0,clock, data, rdaddress, rden, wraddress, wren, q);
    end

endmodule
