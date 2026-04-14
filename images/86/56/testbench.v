`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg scan_done_tick;
    reg [7:0] scan_out;
    wire got_code_tick;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .scan_done_tick(scan_done_tick),
        .scan_out(scan_out),
        .got_code_tick(got_code_tick)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            scan_done_tick = 0;
            scan_out = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Make Code (0x1C)", test_num);
            reset_dut();

            @(negedge clk);
            scan_out = 8'h1C;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Break Code Sequence (0xF0, 0x1C)", test_num);
            reset_dut();


            @(negedge clk);
            scan_out = 8'hF0;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            repeat(2) @(negedge clk);
            scan_out = 8'h1C;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Make Code after Break Sequence", test_num);
            reset_dut();


            @(negedge clk);
            scan_out = 8'hF0;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;

            repeat(2) @(negedge clk);
            scan_out = 8'h1C;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            repeat(2) @(negedge clk);
            scan_out = 8'h23;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extended Code Prefix (0xE0)", test_num);
            reset_dut();

            @(negedge clk);
            scan_out = 8'hE0;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Make Codes", test_num);
            reset_dut();


            @(negedge clk);
            scan_out = 8'h1C;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            repeat(2) @(negedge clk);
            scan_out = 8'h23;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Recovery", test_num);
            reset_dut();


            @(negedge clk);
            scan_out = 8'hF0;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;


            repeat(1) @(negedge clk);
            reset = 1;
            repeat(2) @(negedge clk);
            reset = 0;


            @(negedge clk);
            scan_out = 8'h1C;
            scan_done_tick = 1;
            @(negedge clk);
            scan_done_tick = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_got_code_tick;
        begin
            if (expected_got_code_tick === (expected_got_code_tick ^ got_code_tick ^ expected_got_code_tick)) begin
                $display("PASS");
                $display("  Outputs: got_code_tick=%b",
                         got_code_tick);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: got_code_tick=%b",
                         expected_got_code_tick);
                $display("  Got:      got_code_tick=%b",
                         got_code_tick);
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
        $dumpvars(0,clk, reset, scan_done_tick, scan_out, got_code_tick);
    end

endmodule
