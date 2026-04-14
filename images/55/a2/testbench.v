`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg clk;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .wd(wd),
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
            a = 32'h0;
            wd = 32'h0;
            we = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Write/Read", test_num);


            we = 1;
            a = 32'h0000_0000;
            wd = 32'hDEAD_BEEF;
            @(posedge clk);
            #2;
            we = 0;


            #1;



            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write to Address Offset 4", test_num);


            we = 1;
            a = 32'h0000_0004;
            wd = 32'hCAFE_BABE;
            @(posedge clk);
            #2;
            we = 0;


            a = 32'h0000_0004;
            #2;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write Enable Low Verification", test_num);


            we = 1;
            a = 32'h0000_0008;
            wd = 32'h1111_2222;
            @(posedge clk);
            #2;


            we = 0;
            a = 32'h0000_0008;
            wd = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h1111_2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address Alignment Check", test_num);


            we = 1;
            a = 32'h0000_0010;
            wd = 32'hAAAA_5555;
            @(posedge clk);
            #2;
            we = 0;


            a = 32'h0000_0013;
            #2;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Max Address Boundary Check", test_num);


            we = 1;
            a = 32'h0000_00FC;
            wd = 32'h5A5A_A5A5;
            @(posedge clk);
            #2;
            we = 0;


            a = 32'h0000_00FC;
            #2;
            #1;

            check_outputs(32'h5A5A_A5A5);
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
        $dumpvars(0,a, clk, wd, we, rd);
    end

endmodule
