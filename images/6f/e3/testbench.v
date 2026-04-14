`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] ra;
    reg rce;
    reg [10:0] wa;
    reg wce;
    reg [7:0] wd;
    wire [7:0] rq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra(ra),
        .rce(rce),
        .wa(wa),
        .wce(wce),
        .wd(wd),
        .rq(rq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ra = 0;
            rce = 0;
            wa = 0;
            wce = 0;
            wd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write then Read", test_num);


            wa = 11'h010; wd = 8'hA5; wce = 1;
            @(posedge clk); #1;
            wce = 0;


            ra = 11'h010; rce = 1;
            @(posedge clk); #1;
            rce = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Check - Max Address (2047)", test_num);


            wa = 11'h7FF; wd = 8'h55; wce = 1;
            @(posedge clk); #1;
            wce = 0;


            ra = 11'h7FF; rce = 1;
            @(posedge clk); #1;
            rce = 0;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable (wce) logic check", test_num);


            wa = 11'h020; wd = 8'h11; wce = 1;
            @(posedge clk); #1;


            wa = 11'h020; wd = 8'h22; wce = 0;
            @(posedge clk); #1;


            ra = 11'h020; rce = 1;
            @(posedge clk); #1;
            rce = 0;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Read Enable (rce) logic check", test_num);


            wa = 11'h030; wd = 8'hBB; wce = 1;
            @(posedge clk); #1;
            wce = 0;


            ra = 11'h010; rce = 1;
            @(posedge clk); #1;


            ra = 11'h030; rce = 0;
            @(posedge clk); #1;


            if (rq === 8'hBB) begin
                $display("FAIL: rq updated despite rce being low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: rq did not update when rce was low");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Simultaneous Read and Write", test_num);


            wa = 11'h040; wd = 8'hCC; wce = 1;
            @(posedge clk); #1;
            wce = 0;


            wa = 11'h050; wd = 8'hDD; wce = 1;
            ra = 11'h040; rce = 1;
            @(posedge clk); #1;
            wce = 0; rce = 0;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Check - Address 0", test_num);

            wa = 11'h000; wd = 8'hFF; wce = 1;
            @(posedge clk); #1;
            wce = 0;

            ra = 11'h000; rce = 1;
            @(posedge clk); #1;
            rce = 0;

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_rq;
        begin
            if (expected_rq === (expected_rq ^ rq ^ expected_rq)) begin
                $display("PASS");
                $display("  Outputs: rq=%h",
                         rq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rq=%h",
                         expected_rq);
                $display("  Got:      rq=%h",
                         rq);
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
        $dumpvars(0,clk, ra, rce, wa, wce, wd, rq);
    end

endmodule
