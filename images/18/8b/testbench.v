`timescale 1ns/1ps

module VirtualMemoryManager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] virtual_address;
    wire [15:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManager dut (
        .clk(clk),
        .reset(reset),
        .virtual_address(virtual_address),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            virtual_address = 16'h0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            virtual_address = 16'h0005;
            @(posedge clk);
            #1;
            $display("Testcase %0d: VPN 0x00 mapping", test_num);
            #1;

            check_outputs(16'h1005);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            virtual_address = 16'h0120;
            @(posedge clk);
            #1;
            $display("Testcase %0d: VPN 0x01 mapping", test_num);
            #1;

            check_outputs(16'h1120);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            virtual_address = 16'h02FF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: VPN 0x02 mapping (Max Offset)", test_num);
            #1;

            check_outputs(16'h12FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            virtual_address = 16'h0300;
            @(posedge clk);
            #1;
            $display("Testcase %0d: VPN 0x03 mapping (Min Offset)", test_num);
            #1;

            check_outputs(16'h1300);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            virtual_address = 16'h04AB;
            @(posedge clk);
            #1;
            $display("Testcase %0d: VPN 0x04 mapping", test_num);
            #1;

            check_outputs(16'h14AB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManager Testbench");
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
        input [15:0] expected_physical_address;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h",
                         physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h",
                         expected_physical_address);
                $display("  Got:      physical_address=%h",
                         physical_address);
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
        $dumpvars(0,clk, reset, virtual_address, physical_address);
    end

endmodule
