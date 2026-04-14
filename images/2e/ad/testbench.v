`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] virtual_addr;
    reg write_enable;
    wire dirty_bit;
    wire page_fault;
    wire [4:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagement dut (
        .clk(clk),
        .virtual_addr(virtual_addr),
        .write_enable(write_enable),
        .dirty_bit(dirty_bit),
        .page_fault(page_fault),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            virtual_addr = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Read valid clean page", test_num);
            reset_dut();

            virtual_addr = 5'h05;
            write_enable = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 5'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to valid page (Set Dirty)", test_num);
            reset_dut();


            virtual_addr = 5'h0A;
            write_enable = 1;
            @(posedge clk);
            #2;


            write_enable = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b0, 5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Access invalid page (Page Fault)", test_num);
            reset_dut();



            virtual_addr = 5'h1F;
            write_enable = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(dirty_bit, 1'b1, physical_addr);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write to invalid page", test_num);
            reset_dut();

            virtual_addr = 5'h1E;
            write_enable = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(dirty_bit, 1'b1, physical_addr);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Address Isolation Check", test_num);
            reset_dut();


            virtual_addr = 5'h02;
            write_enable = 1;
            @(posedge clk);
            #2;


            virtual_addr = 5'h03;
            write_enable = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 5'h03);
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
        input expected_dirty_bit;
        input expected_page_fault;
        input [4:0] expected_physical_addr;
        begin
            if (expected_dirty_bit === (expected_dirty_bit ^ dirty_bit ^ expected_dirty_bit) &&
                expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: dirty_bit=%b, page_fault=%b, physical_addr=%h",
                         dirty_bit, page_fault, physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dirty_bit=%b, page_fault=%b, physical_addr=%h",
                         expected_dirty_bit, expected_page_fault, expected_physical_addr);
                $display("  Got:      dirty_bit=%b, page_fault=%b, physical_addr=%h",
                         dirty_bit, page_fault, physical_addr);
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
        $dumpvars(0,clk, virtual_addr, write_enable, dirty_bit, page_fault, physical_addr);
    end

endmodule
