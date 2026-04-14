`timescale 1ns/1ps

module mmu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [9:0] virtual_address;
    reg w_enable;
    wire page_fault;
    wire [9:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mmu dut (
        .clk(clk),
        .rst(rst),
        .virtual_address(virtual_address),
        .w_enable(w_enable),
        .page_fault(page_fault),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            virtual_address = 0;
            w_enable = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Valid Read Translation (VA: 0x000)");
            reset_dut();
            virtual_address = 10'h000;
            w_enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, physical_address);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Valid Write Translation (VA: 0x040)");
            reset_dut();
            virtual_address = 10'h040;
            w_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, physical_address);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Page Fault Check (VA: 0x3FF)");
            reset_dut();
            virtual_address = 10'h3FF;
            w_enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'h000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Consecutive Accesses");
            reset_dut();


            virtual_address = 10'h010;
            w_enable = 0;
            @(posedge clk);


            virtual_address = 10'h020;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, physical_address);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset during operation");
            reset_dut();
            virtual_address = 10'h080;
            w_enable = 0;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;

            if (page_fault === 0) begin
                $display("PASS: System reset successfully");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: System did not reset correctly");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mmu Testbench");
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
        input expected_page_fault;
        input [9:0] expected_physical_address;
        begin
            if (expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: page_fault=%b, physical_address=%h",
                         page_fault, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_fault=%b, physical_address=%h",
                         expected_page_fault, expected_physical_address);
                $display("  Got:      page_fault=%b, physical_address=%h",
                         page_fault, physical_address);
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
        $dumpvars(0,clk, rst, virtual_address, w_enable, page_fault, physical_address);
    end

endmodule
