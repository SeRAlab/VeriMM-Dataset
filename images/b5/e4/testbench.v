`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [35:0] data;
    reg [7:0] rdaddress;
    reg [7:0] wraddress;
    reg wren;
    wire [35:0] q;

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
            data <= 0;
            rdaddress <= 0;
            wraddress <= 0;
            wren <= 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            wren = 1;
            wraddress = 8'h01;
            data = 36'h5_5555_AAAA;
            @(posedge clock);
            #1;


            wren = 0;
            rdaddress = 8'h01;
            #2;

            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(36'h5_5555_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            wren = 1;
            wraddress = 8'hFF;
            data = 36'hF_FFFF_FFFF;
            @(posedge clock);
            #1;


            wren = 0;
            rdaddress = 8'hFF;
            #2;

            $display("Testcase %0d: Boundary Address 0xFF", test_num);
            #1;

            check_outputs(36'hF_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            wren = 1;
            wraddress = 8'h10;
            data = 36'h1_2345_6789;
            @(posedge clock);
            #1;


            wren = 0;
            wraddress = 8'h10;
            data = 36'h0_0000_0000;
            @(posedge clock);
            #1;


            rdaddress = 8'h10;
            #2;

            $display("Testcase %0d: Verify wren inhibits write", test_num);
            #1;

            check_outputs(36'h1_2345_6789);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            wren = 1;
            wraddress = 8'h20;
            data = 36'hA_0000_B000;
            @(posedge clock);
            #1;


            wraddress = 8'h21;
            data = 36'hC_0000_D000;
            @(posedge clock);
            #1;

            wren = 0;
            rdaddress = 8'h20;
            #2;


            rdaddress = 8'h21;
            #2;

            $display("Testcase %0d: Sequential write/read (checking last read)", test_num);
            #1;

            check_outputs(36'hC_0000_D000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            wren = 1;
            wraddress = 8'h50;
            data = 36'hE_EEEE_EEEE;
            @(posedge clock);
            #1;


            wren = 1;
            wraddress = 8'h60;
            data = 36'hF_FFFF_FFFF;
            rdaddress = 8'h50;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Simultaneous Read/Write different addr", test_num);
            #1;

            check_outputs(36'hE_EEEE_EEEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            wren = 1;
            wraddress = 8'h00;
            data = 36'h3_3333_3333;
            @(posedge clock);
            #1;

            wren = 0;
            rdaddress = 8'h00;
            #2;

            $display("Testcase %0d: Address 0x00 Test", test_num);
            #1;

            check_outputs(36'h3_3333_3333);
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
        input [35:0] expected_q;
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
