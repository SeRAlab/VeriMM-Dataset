`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] DIN;
    reg [8:0] RA;
    reg [8:0] WA;
    reg memclk;
    reg rd_in;
    reg rst;
    reg wr_in;
    wire [5:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .RA(RA),
        .WA(WA),
        .memclk(memclk),
        .rd_in(rd_in),
        .rst(rst),
        .wr_in(wr_in),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        memclk = 0;
        forever #5 memclk = ~memclk;
    end

        task reset_dut;

        begin
            rst = 1;
            rd_in = 0;
            wr_in = 0;
            DIN = 0;
            RA = 0;
            WA = 0;
            repeat(2) @(posedge memclk);
            #1 rst = 0;
            repeat(1) @(posedge memclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();

            @(negedge memclk);
            wr_in = 1;
            WA = 9'h00A;
            DIN = 6'h2A;

            @(negedge memclk);
            wr_in = 0;
            rd_in = 1;
            RA = 9'h00A;

            @(posedge memclk);
            #2 #1;
 check_outputs(6'h2A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read/Write Different Addr", test_num);
            reset_dut();


            @(negedge memclk);
            wr_in = 1;
            WA = 9'h005;
            DIN = 6'h15;

            @(negedge memclk);

            wr_in = 1;
            WA = 9'h010;
            DIN = 6'h3F;
            rd_in = 1;
            RA = 9'h005;

            @(posedge memclk);
            #2 #1;
 check_outputs(6'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Write Enable", test_num);
            reset_dut();


            @(negedge memclk);
            wr_in = 1;
            WA = 9'h020;
            DIN = 6'h01;

            @(negedge memclk);

            wr_in = 0;
            WA = 9'h020;
            DIN = 6'h33;

            @(negedge memclk);
            rd_in = 1;
            RA = 9'h020;

            @(posedge memclk);
            #2 #1;
 check_outputs(6'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Read Enable and Retention", test_num);
            reset_dut();


            @(negedge memclk);
            wr_in = 1; WA = 9'h001; DIN = 6'h11;
            @(negedge memclk);
            wr_in = 1; WA = 9'h002; DIN = 6'h22;

            @(negedge memclk);
            wr_in = 0;
            rd_in = 1;
            RA = 9'h001;

            @(negedge memclk);
            rd_in = 0;
            RA = 9'h002;

            @(posedge memclk);
            #2 #1;
 check_outputs(6'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Inhibits Changes", test_num);
            reset_dut();


            @(negedge memclk);
            wr_in = 1; WA = 9'h050; DIN = 6'h05;
            @(negedge memclk);
            wr_in = 0; rd_in = 1; RA = 9'h050;
            @(posedge memclk);

            @(negedge memclk);
            rst = 1;
            wr_in = 1; WA = 9'h050; DIN = 6'h3F;
            rd_in = 1; RA = 9'h000;

            @(negedge memclk);
            rst = 0;
            wr_in = 0;
            rd_in = 1;
            RA = 9'h050;

            @(posedge memclk);
            #2 #1;
 check_outputs(6'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Address and Data", test_num);
            reset_dut();

            @(negedge memclk);
            wr_in = 1;
            WA = 9'h1FF;
            DIN = 6'h3F;

            @(negedge memclk);
            wr_in = 0;
            rd_in = 1;
            RA = 9'h1FF;

            @(posedge memclk);
            #2 #1;
 check_outputs(6'h3F);
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
        input [5:0] expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
        $dumpvars(0,DIN, RA, WA, memclk, rd_in, rst, wr_in, DOUT);
    end

endmodule
