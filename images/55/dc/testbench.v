`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] data;
    reg [6:0] rdaddress;
    reg [6:0] wraddress;
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
            wraddress = 0;
            rdaddress = 0;
            data = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            @(posedge clock);
            wren = 1;
            wraddress = 7'h10;
            data = 32'hA5A5A5A5;


            @(posedge clock);
            wren = 0;
            rdaddress = 7'h10;


            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);


            @(posedge clock);
            wren = 0;
            wraddress = 7'h20;
            data = 32'hFFFFFFFF;


            @(posedge clock);
            wren = 1;
            wraddress = 7'h20;
            data = 32'h12345678;


            @(posedge clock);
            wren = 0;
            wraddress = 7'h20;
            data = 32'h87654321;


            @(posedge clock);
            rdaddress = 7'h20;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);


            @(posedge clock);
            wren = 1;
            wraddress = 7'h05;
            data = 32'hBEEFCAFE;


            @(posedge clock);
            wraddress = 7'h06;
            data = 32'hCAFEBEEF;
            rdaddress = 7'h05;
            wren = 1;


            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hBEEFCAFE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (127)", test_num);

            @(posedge clock);
            wren = 1;
            wraddress = 7'd127;
            data = 32'h55AA55AA;

            @(posedge clock);
            wren = 0;
            rdaddress = 7'd127;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite", test_num);

            @(posedge clock);
            wren = 1;
            wraddress = 7'h40;
            data = 32'h11111111;

            @(posedge clock);
            data = 32'h22222222;

            @(posedge clock);
            wren = 0;
            rdaddress = 7'h40;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h22222222);
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
