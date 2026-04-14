`timescale 1ns/1ps

module VirtualMemory_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [9:0] virtual_address;
    wire [9:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemory dut (
        .clock(clock),
        .virtual_address(virtual_address),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            virtual_address = 10'h000;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            virtual_address = 10'h000;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Virtual Address 0x000", test_num);

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            virtual_address = 10'h3FF;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Virtual Address 0x3FF", test_num);
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            virtual_address = 10'h200;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Virtual Address 0x200", test_num);
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            virtual_address = 10'h155;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Virtual Address 0x155", test_num);
            #1;

            check_outputs(10'h155);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            virtual_address = 10'h07F;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Virtual Address 0x07F", test_num);
            #1;

            check_outputs(10'h07F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemory Testbench");
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
        input [9:0] expected_physical_address;
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
        $dumpvars(0,clock, virtual_address, physical_address);
    end

endmodule
