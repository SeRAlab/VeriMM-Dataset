`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] virtual_address;
    wire page_fault;
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
            virtual_address = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Valid Translation Page 0", test_num);
            reset_dut();
            virtual_address = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Valid Translation Page 1", test_num);
            reset_dut();
            virtual_address = 8'h1A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h2A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Valid Translation Page 2", test_num);
            reset_dut();
            virtual_address = 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Page Fault - High Address", test_num);
            reset_dut();
            virtual_address = 8'hF0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Page Fault - Middle Address", test_num);
            reset_dut();
            virtual_address = 8'h44;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Boundary Offset Check", test_num);
            reset_dut();
            virtual_address = 8'h0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h1F);
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
        $dumpvars(0,clk, reset, virtual_address, page_fault, physical_address);
    end

endmodule
