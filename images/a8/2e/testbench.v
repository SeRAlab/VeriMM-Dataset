`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr0;
    reg [12:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [7:0] d0;
    reg [7:0] d1;
    reg we0;
    reg we1;
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
        .d1(d1),
        .we0(we0),
        .we1(we1),
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
            addr0 = 0; addr1 = 0;
            ce0 = 0; ce1 = 0;
            we0 = 0; we1 = 0;
            d0 = 0; d1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Port 0 Basic Write/Read");


            @(posedge clk);
            addr0 = 13'd10; d0 = 8'hA5; ce0 = 1; we0 = 1;
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
            test_num = 2;
            $display("Testcase 002: Port 1 Basic Write/Read");


            @(posedge clk);
            addr1 = 13'd200; d1 = 8'h5A; ce1 = 1; we1 = 1;
            @(posedge clk);


            we1 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(q0, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Simultaneous Writes");


            @(posedge clk);
            addr0 = 13'd30; d0 = 8'h11; ce0 = 1; we0 = 1;
            addr1 = 13'd40; d1 = 8'h22; ce1 = 1; we1 = 1;
            @(posedge clk);


            we0 = 0; we1 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Port 0 Write / Port 1 Read Concurrent");


            @(posedge clk);
            addr1 = 13'd50; d1 = 8'hEE; ce1 = 1; we1 = 1;
            @(posedge clk);


            addr0 = 13'd60; d0 = 8'hFF; we0 = 1; ce0 = 1;
            addr1 = 13'd50; we1 = 0; ce1 = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(q0, 8'hEE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Chip Enable Check");


            @(posedge clk);
            addr0 = 13'd100; d0 = 8'h99; ce0 = 0; we0 = 1;
            @(posedge clk);


            ce0 = 1; we0 = 0;
            @(posedge clk);
            #2;


            if (q0 !== 8'h99) begin
                pass_count = pass_count + 1;
                $display("PASS: ce=0 prevented write.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: ce=0 allowed write.");
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Max Boundary Address 5759");


            @(posedge clk);
            addr0 = 13'd5759; d0 = 8'h77; ce0 = 1; we0 = 1;
            @(posedge clk);

            we0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h77, q1);
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d0, d1, we0, we1, q0, q1);
    end

endmodule
