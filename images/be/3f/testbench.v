`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr1;
    reg [15:0] addr2;
    reg clk;
    reg [17:0] data1;
    reg [17:0] data2;
    reg we1;
    reg we2;
    wire [17:0] out1;
    wire [17:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .we1(we1),
        .we2(we2),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we1 = 0;
            we2 = 0;
            addr1 = 0;
            addr2 = 0;
            data1 = 0;
            data2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write/Read Port 1");
            reset_dut();
            addr1 = 16'hA001;
            data1 = 18'h3ABCD;
            we1 = 1;
            @(posedge clk);
            #1 we1 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(18'h3ABCD, 18'hzzzzz);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write/Read Port 2");
            reset_dut();
            addr2 = 16'hB002;
            data2 = 18'h25555;
            we1 = 0;
            we2 = 1;
            @(posedge clk);
            #1 we2 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(18'hzzzzz, 18'h25555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Priority Check (we1 inhibits we2)");
            reset_dut();
            addr1 = 16'hC001;
            data1 = 18'h11111;
            addr2 = 16'hC002;
            data2 = 18'h22222;
            we1 = 1;
            we2 = 1;
            @(posedge clk);
            #1;
            we1 = 0;
            we2 = 0;

            addr1 = 16'hC001;
            addr2 = 16'hC002;
            @(posedge clk);
            #1 #1;
 check_outputs(18'h11111, 18'h00000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Dual Port Simultaneous Read");
            reset_dut();

            addr1 = 16'h1000; data1 = 18'h0AAAA; we1 = 1; @(posedge clk); #1;
            addr1 = 16'h2000; data1 = 18'h0BBBB; we1 = 1; @(posedge clk); #1;
            we1 = 0;

            addr1 = 16'h1000;
            addr2 = 16'h2000;
            @(posedge clk);
            #1 #1;
 check_outputs(18'h0AAAA, 18'h0BBBB);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write Disable Check");
            reset_dut();
            addr1 = 16'hFFFF;
            data1 = 18'h3FFFF;
            we1 = 0;
            we2 = 0;
            @(posedge clk);
            #1;
            addr1 = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(18'h00000, 18'hzzzzz);
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
        input [17:0] expected_out1;
        input [17:0] expected_out2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
        $dumpvars(0,addr1, addr2, clk, data1, data2, we1, we2, out1, out2);
    end

endmodule
