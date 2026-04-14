`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ra;
    reg [31:0] wd0;
    reg [31:0] wd1;
    reg we;
    wire [31:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra(ra),
        .wd0(wd0),
        .wd1(wd1),
        .we(we),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            ra = 0;
            wd0 = 32'h0;
            wd1 = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Write to both registers, read Reg0", test_num);


            wd0 = 32'hAAAAAAAA;
            wd1 = 32'h55555555;
            we = 1;

            @(posedge clk);
            #2;

            we = 0;
            ra = 0;
            #2;

            #1;


            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Write to both registers, read Reg1", test_num);


            wd0 = 32'h12345678;
            wd1 = 32'hFEDCBA98;
            we = 1;

            @(posedge clk);
            #2;

            we = 0;
            ra = 1;
            #2;

            #1;


            check_outputs(32'hFEDCBA98);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Verify Write Enable (we=0)", test_num);


            wd0 = 32'h11111111;
            wd1 = 32'h22222222;
            we = 1;
            @(posedge clk);
            #2;


            wd0 = 32'hDEADBEEF;
            wd1 = 32'hCAFEBABE;
            we = 0;
            @(posedge clk);
            #2;


            ra = 0;
            #2;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Verify Reg1 was also not overwritten", test_num);


            wd0 = 32'hAAAA0000;
            wd1 = 32'hBBBB1111;
            we = 1;
            @(posedge clk);
            #2;


            wd0 = 32'hFFFFFFFF;
            wd1 = 32'hFFFFFFFF;
            we = 0;
            @(posedge clk);
            #2;

            ra = 1;
            #2;
            #1;

            check_outputs(32'hBBBB1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Check combinational address switching (ra)", test_num);

            wd0 = 32'h00000001;
            wd1 = 32'h80000000;
            we = 1;
            @(posedge clk);
            #2;

            we = 0;

            ra = 0; #5;
            ra = 1; #5;

            #1;


            check_outputs(32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Write all zeros", test_num);

            wd0 = 32'hFFFFFFFF;
            wd1 = 32'hFFFFFFFF;
            we = 1;
            @(posedge clk);
            #2;

            wd0 = 32'h0;
            wd1 = 32'h0;
            we = 1;
            @(posedge clk);
            #2;

            ra = 0;
            #2;
            #1;

            check_outputs(32'h0);
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
        input [31:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,clk, ra, wd0, wd1, we, rd);
    end

endmodule
