`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [9:0] virtual_addr;
    wire [9:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagement dut (
        .clk(clk),
        .rst(rst),
        .virtual_addr(virtual_addr),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            virtual_addr = 10'h000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing VPN 0 with offset 0x50", test_num);
            reset_dut();
            virtual_addr = 10'h050;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h250);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing VPN 1 with offset 0xA0", test_num);
            reset_dut();
            virtual_addr = 10'h1A0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3A0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing VPN 2 with offset 0x22", test_num);
            reset_dut();
            virtual_addr = 10'h222;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h122);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing VPN 3 with max offset 0xFF", test_num);
            reset_dut();
            virtual_addr = 10'h3FF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h0FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing VPN 2 with zero offset", test_num);
            reset_dut();
            virtual_addr = 10'h200;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing VPN 0 with offset 0x01", test_num);
            reset_dut();
            virtual_addr = 10'h001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h201);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManagement Testbench");
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
        input [9:0] expected_physical_addr;
        begin
            if (expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: physical_addr=%h",
                         physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_addr=%h",
                         expected_physical_addr);
                $display("  Got:      physical_addr=%h",
                         physical_addr);
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
        $dumpvars(0,clk, rst, virtual_addr, physical_addr);
    end

endmodule
