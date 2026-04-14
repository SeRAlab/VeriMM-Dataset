`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] addr1;
    reg [10:0] addr2;
    reg clk1;
    reg clk2;
    reg [39:0] data1;
    reg [39:0] data2;
    reg oe1;
    reg oe2;
    reg we1;
    reg we2;
    wire [39:0] q1;
    wire [39:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk1(clk1),
        .clk2(clk2),
        .data1(data1),
        .data2(data2),
        .oe1(oe1),
        .oe2(oe2),
        .we1(we1),
        .we2(we2),
        .q1(q1),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
    end

        task reset_dut;

        begin
            addr1 = 0; addr2 = 0;
            data1 = 0; data2 = 0;
            we1 = 0; we2 = 0;
            oe1 = 0; oe2 = 0;
            repeat(2) @(posed_edge_both);
        end
        endtask
    task posed_edge_both;

        begin
            @(posedge clk1);
            @(posedge clk2);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Port 1 Write/Read", test_num);


            @(posedge clk1);
            addr1 = 11'h0A; data1 = 40'hDEADBEEF01; we1 = 1;
            @(posedge clk1);
            we1 = 0;


            @(posedge clk1);
            addr1 = 11'h0A; oe1 = 1;
            @(posedge clk1);
            #1;
            #1;

            check_outputs(40'hDEADBEEF01, 40'hx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Port 2 Write/Read", test_num);


            @(posedge clk2);
            addr2 = 11'h1F; data2 = 40'hCAFEBABE02; we2 = 1;
            @(posedge clk2);
            we2 = 0;


            @(posedge clk2);
            addr2 = 11'h1F; oe2 = 1;
            @(posedge clk2);
            #1;
            #1;

            check_outputs(40'hx, 40'hCAFEBABE02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Cross-port (P1 Write, P2 Read)", test_num);


            @(posedge clk1);
            addr1 = 11'h100; data1 = 40'h123456789A; we1 = 1;
            @(posedge clk1);
            we1 = 0;


            @(posedge clk2);
            addr2 = 11'h100; oe2 = 1;
            @(posedge clk2);
            #1;
            #1;

            check_outputs(40'hx, 40'h123456789A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Simultaneous Write", test_num);

            fork
                begin
                    @(posedge clk1);
                    addr1 = 11'h200; data1 = 40'hAAAA_AAAA_AA; we1 = 1;
                    @(posedge clk1); we1 = 0;
                end
                begin
                    @(posedge clk2);
                    addr2 = 11'h300; data2 = 40'hBBBB_BBBB_BB; we2 = 1;
                    @(posedge clk2); we2 = 0;
                end
            join


            @(posedge clk1); addr1 = 11'h200; oe1 = 1;
            @(posedge clk2); addr2 = 11'h300; oe2 = 1;
            voiced_delay(2);
            #1;
            #1;

            check_outputs(40'hAAAA_AAAA_AA, 40'hBBBB_BBBB_BB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Output Enable Check", test_num);


            @(posedge clk1);
            addr1 = 11'h55; data1 = 40'h5555_5555_55; we1 = 1;
            @(posedge clk1); we1 = 0;


            @(posedge clk1);
            addr1 = 11'h55; oe1 = 0;
            @(posedge clk1);
            #1;
            if (q1 === 40'h0 || q1 === 40'bz) begin

            end else begin

            end


            oe1 = 1;
            @(posedge clk1);
            #1;
            #1;

            check_outputs(40'h5555_5555_55, 40'hx);
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
        input [39:0] expected_q1;
        input [39:0] expected_q2;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h",
                         q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h",
                         expected_q1, expected_q2);
                $display("  Got:      q1=%h, q2=%h",
                         q1, q2);
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
        $dumpvars(0,addr1, addr2, clk1, clk2, data1, data2, oe1, oe2, we1, we2, q1, q2);
    end

endmodule
