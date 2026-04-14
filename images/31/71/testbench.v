`timescale 1ns/1ps

module virtual_memory_management_unit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_enable;
    reg reset;
    reg [7:0] virtual_address;
    reg write_enable;
    wire page_fault;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management_unit dut (
        .clk(clk),
        .read_enable(read_enable),
        .reset(reset),
        .virtual_address(virtual_address),
        .write_enable(write_enable),
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
            reset = 1;
            read_enable = 0;
            write_enable = 0;
            virtual_address = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Read Translation...");
            reset_dut();
            virtual_address = 8'h05;
            read_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h05);
            read_enable = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Page Fault Detection...");
            reset_dut();
            virtual_address = 8'hF0;
            read_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'hXX);
            read_enable = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Write Translation...");
            reset_dut();
            virtual_address = 8'h1A;
            write_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h1A);
            write_enable = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Reset During Operation...");
            reset_dut();
            virtual_address = 8'h02;
            read_enable = 1;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h00);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Consecutive Accesses...");
            reset_dut();


            virtual_address = 8'h22;
            read_enable = 1;
            @(posedge clk);
            #2;


            virtual_address = 8'h33;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 8'h33);
            read_enable = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management_unit Testbench");
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
        input [7:0] expected_physical_address;
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
        $dumpvars(0,clk, read_enable, reset, virtual_address, write_enable, page_fault, physical_address);
    end

endmodule
