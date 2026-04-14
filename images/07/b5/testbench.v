`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] virtual_address;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagement dut (
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
            virtual_address = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            virtual_address = 8'h05;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Running testcase001: Page 0, Offset 5");
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            virtual_address = 8'h1A;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Running testcase002: Page 1, Offset A");
            #1;

            check_outputs(8'h1A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            virtual_address = 8'h2F;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Running testcase003: Page 2, Offset F");
            #1;

            check_outputs(8'h2F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            virtual_address = 8'h30;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Running testcase004: Page 3, Offset 0");
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            test_num = test_num + 1;
            $display("Running testcase005: Reset State Verification");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            virtual_address = 8'h11;
            @(posedge clk);
            #2;

            virtual_address = 8'h22;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Running testcase006: Consecutive Translation (Page 2, Offset 2)");
            #1;

            check_outputs(8'h22);
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
        input [7:0] expected_physical_address;
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
