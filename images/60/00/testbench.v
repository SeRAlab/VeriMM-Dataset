`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr1;
    reg [9:0] addr2;
    reg clk;
    reg [7:0] din1;
    reg [7:0] din2;
    reg wren1;
    reg wren2;
    wire [7:0] dout1;
    wire [7:0] dout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .din1(din1),
        .din2(din2),
        .wren1(wren1),
        .wren2(wren2),
        .dout1(dout1),
        .dout2(dout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wren1 = 0;
            wren2 = 0;
            addr1 = 0;
            addr2 = 0;
            din1 = 0;
            din2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Port 1 Write and Read", test_num);
            addr1 = 10'd42;
            din1 = 8'hAA;
            wren1 = 1;
            @(posedge clk);
            #1;
            wren1 = 0;
            addr1 = 10'd42;
            addr2 = 0;
            #2;
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Port 2 Write and Read", test_num);
            addr2 = 10'd100;
            din2 = 8'h55;
            wren1 = 0;
            wren2 = 1;
            @(posedge clk);
            #1;
            wren2 = 0;
            addr1 = 0;
            addr2 = 10'd100;
            #2;
            #1;

            check_outputs(8'h00, 8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Priority Check (wren1 should block wren2)", test_num);

            addr1 = 10'd200;
            din1 = 8'h11;
            wren1 = 1;

            addr2 = 10'd300;
            din2 = 8'h22;
            wren2 = 1;
            @(posedge clk);
            #1;
            wren1 = 0;
            wren2 = 0;

            addr1 = 10'd200;
            addr2 = 10'd300;
            #2;
            #1;

            check_outputs(8'h11, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Concurrent Dual Port Read", test_num);

            addr1 = 10'd10; din1 = 8'hA1; wren1 = 1;
            @(posedge clk); #1;
            wren1 = 0; addr2 = 10'd20; din2 = 8'hB2; wren2 = 1;
            @(posedge clk); #1;
            wren2 = 0;

            addr1 = 10'd10;
            addr2 = 10'd20;
            #2;
            #1;

            check_outputs(8'hA1, 8'hB2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Address (1023)", test_num);
            addr1 = 10'd1023;
            din1 = 8'hFF;
            wren1 = 1;
            @(posedge clk);
            #1;
            wren1 = 0;
            addr1 = 10'd1023;
            addr2 = 10'd1023;
            #2;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Same Address Read", test_num);
            addr1 = 10'd512;
            din1 = 8'h99;
            wren1 = 1;
            @(posedge clk);
            #1;
            wren1 = 0;
            addr1 = 10'd512;
            addr2 = 10'd512;
            #2;
            #1;

            check_outputs(8'h99, 8'h99);
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
        input [7:0] expected_dout1;
        input [7:0] expected_dout2;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h",
                         dout1, dout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h",
                         expected_dout1, expected_dout2);
                $display("  Got:      dout1=%h, dout2=%h",
                         dout1, dout2);
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
        $dumpvars(0,addr1, addr2, clk, din1, din2, wren1, wren2, dout1, dout2);
    end

endmodule
