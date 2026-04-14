`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] addr0;
    reg [8:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [7:0] d0;
    reg we0;
    wire [7:0] q0;
    wire [7:0] q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .d0(d0),
        .we0(we0),
        .q0(q0),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 0;
            addr1 = 0;
            ce0 = 0;
            ce1 = 0;
            d0 = 0;
            we0 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Executing testcase%03d: Port 0 Basic R/W", test_num);


            @(posedge clk);
            addr0 = 9'd10; d0 = 8'hA5; we0 = 1; ce0 = 1;
            @(posedge clk);


            we0 = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hA5, q1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Executing testcase%03d: Port 1 Read Cross-check", test_num);


            @(posedge clk);
            addr0 = 9'd50; d0 = 8'h5A; we0 = 1; ce0 = 1;
            @(posedge clk);


            ce0 = 0; we0 = 0;
            addr1 = 9'd50; ce1 = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(q0, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Executing testcase%03d: Simultaneous Port Access", test_num);


            @(posedge clk);
            addr0 = 9'd100; d0 = 8'h11; we0 = 1; ce0 = 1;
            @(posedge clk);


            addr0 = 9'd200; d0 = 8'h22; we0 = 1; ce0 = 1;
            addr1 = 9'd100; ce1 = 1;
            @(posedge clk);


            we0 = 0; addr0 = 9'd200;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Executing testcase%03d: Chip Enable Validation", test_num);


            @(posedge clk);
            addr0 = 9'd300; d0 = 8'hFF; we0 = 1; ce0 = 0;
            @(posedge clk);


            we0 = 0; ce0 = 1; addr0 = 9'd300;
            @(posedge clk);
            #2;


            if (q0 === 8'hFF) begin
                $display("FAIL: Write occurred despite ce0 being low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: ce0 inhibited write");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Executing testcase%03d: Sequential Line Pattern", test_num);


            for(i=0; i<4; i=i+1) begin
                @(posedge clk);
                addr0 = i; d0 = i; we0 = 1; ce0 = 1;
            end

            @(posedge clk);
            we0 = 0; ce0 = 1; ce1 = 1;


            addr0 = 9'd3;
            addr1 = 9'd2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h03, 8'h02);
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
        input [7:0] expected_q0;
        input [7:0] expected_q1;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h",
                         q0, q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h",
                         expected_q0, expected_q1);
                $display("  Got:      q0=%h, q1=%h",
                         q0, q1);
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d0, we0, q0, q1);
    end

endmodule
