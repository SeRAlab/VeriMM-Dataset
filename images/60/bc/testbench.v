`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] ra;
    reg rce;
    reg [9:0] wa;
    reg wce;
    reg [15:0] wd;
    wire [15:0] rq;

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
            $display("Test %0d: Basic Write and Read at address 0x000", test_num);


            wa = 10'h000;
            wd = 16'hABCD;
            wce = 1;
            @(posedge clk);
            #1;
            wce = 0;


            ra = 10'h000;
            rce = 1;
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Read Enable (rce) forced zero check", test_num);


            wa = 10'h010;
            wd = 16'h1234;
            wce = 1;
            @(posedge clk);
            #1;
            wce = 0;


            ra = 10'h010;
            rce = 0;
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Write Enable (wce) low check", test_num);


            wa = 10'h020;
            wd = 16'h5555;
            wce = 0;
            @(posedge clk);
            #1;


            ra = 10'h020;
            rce = 1;
            #2;
            if (rq === 16'h5555) begin
                $display("FAIL: Data written while wce was low");
                fail_count = fail_count + 1;
            end else begin
                pass_count = pass_count + 1;
                $display("PASS: Data not written when wce low");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Max address boundary check (0x3FF)", test_num);

            wa = 10'h3FF;
            wd = 16'hFFFF;
            wce = 1;
            @(posedge clk);
            #1;
            wce = 0;

            ra = 10'h3FF;
            rce = 1;
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Simultaneous Read and Write", test_num);


            wa = 10'h100;
            wd = 16'hAAAA;
            wce = 1;
            @(posedge clk);
            #1;


            wa = 10'h200;
            wd = 16'hBBBB;
            wce = 1;
            ra = 10'h100;
            rce = 1;
            #2;
            #1;

            check_outputs(16'hAAAA);


            @(posedge clk);
            #1;
            wce = 0;
            ra = 10'h200;
            #2;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Multiple sequential operations", test_num);


            for(i=0; i<5; i=i+1) begin
                wa = i;
                wd = i + 16'h1000;
                wce = 1;
                @(posedge clk);
                #1;
            end
            wce = 0;


            ra = 4;
            rce = 1;
            #2;
            #1;

            check_outputs(16'h1004);
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
        input [15:0] expected_rq;
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
