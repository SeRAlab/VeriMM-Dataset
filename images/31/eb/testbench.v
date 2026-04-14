`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] virtual_addr;
    wire [15:0] physical_addr;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .clk(clk),
        .reset(reset),
        .virtual_addr(virtual_addr),
        .physical_addr(physical_addr),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            virtual_addr = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: VPN 0, Offset 000 (Valid Page)");
            virtual_addr = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: VPN 1, Offset ABC (Valid Page)");
            virtual_addr = 16'h1ABC;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1ABC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: VPN 3 (Expected Page Fault)");
            virtual_addr = 16'h3000;
            @(posedge clk);

            #1 #1;
 check_outputs(physical_addr, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: VPN 15, Max Offset (Valid Page)");
            virtual_addr = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: VPN 2, Offset 555 (Valid Page)");
            virtual_addr = 16'h2555;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h2555, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: VPN 7 (Expected Page Fault)");
            virtual_addr = 16'h789A;
            @(posedge clk);
            #1 #1;
 check_outputs(physical_addr, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MMU Testbench");
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
        input [15:0] expected_physical_addr;
        input expected_valid;
        begin
            if (expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: physical_addr=%h, valid=%b",
                         physical_addr, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_addr=%h, valid=%b",
                         expected_physical_addr, expected_valid);
                $display("  Got:      physical_addr=%h, valid=%b",
                         physical_addr, valid);
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
        $dumpvars(0,clk, reset, virtual_addr, physical_addr, valid);
    end

endmodule
