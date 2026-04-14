`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dec;
    reg [15:0] din;
    reg ld;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dec(dec),
        .din(din),
        .ld(ld),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            ld = 1;
            din = 16'h0000;
            dec = 0;
            @(posedge clk);
            #1;
            ld = 0;
            din = 16'h0000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load value 0xABCD", test_num);
            reset_dut();
            ld = 1;
            din = 16'hABCD;
            @(posedge clk);
            #1;
            ld = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x0005 then decrement once", test_num);
            reset_dut();

            ld = 1;
            din = 16'h0005;
            @(posedge clk);
            #1;
            ld = 0;

            dec = 1;
            @(posedge clk);
            #1;
            dec = 0;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement 5 times from 0x000A", test_num);
            reset_dut();

            ld = 1;
            din = 16'h000A;
            @(posedge clk);
            #1;
            ld = 0;

            dec = 1;
            repeat(5) @(posedge clk);
            #1;
            dec = 0;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output remains unchanged when ld=0, dec=0", test_num);
            reset_dut();

            ld = 1;
            din = 16'h1234;
            @(posedge clk);
            #1;
            ld = 0;
            dec = 0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow check (0x0000 - 1 = 0xFFFF)", test_num);
            reset_dut();
            dec = 1;
            @(posedge clk);
            #1;
            dec = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check (ld=1 and dec=1)", test_num);
            reset_dut();
            ld = 1;
            din = 16'h5555;
            dec = 1;
            @(posedge clk);
            #1;
            ld = 0;
            dec = 0;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence Load -> Dec -> Hold -> Dec", test_num);
            reset_dut();

            ld = 1; din = 16'h0100; @(posedge clk); #1;

            ld = 0; dec = 1; repeat(2) @(posedge clk); #1;

            dec = 0; repeat(2) @(posedge clk); #1;

            dec = 1; @(posedge clk); #1;
            dec = 0;

            #1;


            check_outputs(16'h00FD);
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
        testcase007();
        
        
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, dec, din, ld, dout);
    end

endmodule
