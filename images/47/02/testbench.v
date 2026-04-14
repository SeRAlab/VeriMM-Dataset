`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [1:0] rw;
    reg [47:0] wline;
    wire [47:0] rline;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .rw(rw),
        .wline(wline),
        .rline(rline)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 16'h0;
            wline = 48'h0;
            rw = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Addr 0", test_num);

            addr = 16'h0000;
            wline = 48'hAAAA_BBBB_CCCC;
            rw = 2'b10;

            @(posedge clk);
            #2;

            rw = 2'b00;
            #1;

            check_outputs(48'hAAAA_BBBB_CCCC);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 255 (8'hFF)", test_num);

            addr = 16'h00FF;
            wline = 48'h1234_5678_9ABC;
            rw = 2'b10;

            @(posedge clk);
            #2;

            #1;


            check_outputs(48'h1234_5678_9ABC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify rw != 2'b10 prevents write", test_num);


            addr = 16'h0010;
            wline = 48'hDEAF_BEEF_CAFE;
            rw = 2'b10;
            @(posedge clk);
            #2;


            wline = 48'h0000_0000_0000;
            rw = 2'b01;
            @(posedge clk);
            #2;


            #1;



            check_outputs(48'hDEAF_BEEF_CAFE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting data at Addr 0x55", test_num);

            addr = 16'h0055;
            wline = 48'h1111_1111_1111;
            rw = 2'b10;
            @(posedge clk);
            #5;

            wline = 48'hEEEE_EEEE_EEEE;
            rw = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(48'hEEEE_EEEE_EEEE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous Read Address Change", test_num);


            addr = 16'h000A;
            wline = 48'hAAAA_AAAA_AAAA;
            rw = 2'b10;
            @(posedge clk);
            #2;


            addr = 16'h000B;
            wline = 48'hBBBB_BBBB_BBBB;
            rw = 2'b10;
            @(posedge clk);
            #2;


            rw = 2'b00;
            addr = 16'h000A;
            #1;

            #1;


            check_outputs(48'hAAAA_AAAA_AAAA);
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
        input [47:0] expected_rline;
        begin
            if (expected_rline === (expected_rline ^ rline ^ expected_rline)) begin
                $display("PASS");
                $display("  Outputs: rline=%h",
                         rline);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rline=%h",
                         expected_rline);
                $display("  Got:      rline=%h",
                         rline);
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
        $dumpvars(0,addr, clk, rw, wline, rline);
    end

endmodule
