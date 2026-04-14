`timescale 1ns/1ps

module VirtualMemoryManager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_write;
    reg reset;
    reg [7:0] virtual_address;
    wire page_fault;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManager dut (
        .clk(clk),
        .read_write(read_write),
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
            read_write = 0;
            virtual_address = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Translate VA 0x05 (VPN 0) - Expecting PA 0x15", test_num);
            reset_dut();
            virtual_address = 8'h05;
            read_write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Translate VA 0x1A (VPN 1) - Expecting PA 0x2A", test_num);
            reset_dut();
            virtual_address = 8'h1A;
            read_write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h2A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Access unmapped VA 0xF0 - Expecting Page Fault", test_num);
            reset_dut();
            virtual_address = 8'hF0;
            read_write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write to VA 0x22 (VPN 2) - Expecting PA 0x32", test_num);
            reset_dut();
            virtual_address = 8'h22;
            read_write = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Access VA 0x80 (VPN 8) - Expecting Page Fault", test_num);
            reset_dut();
            virtual_address = 8'h80;
            read_write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Translate VA 0x3F (Last byte of VPN 3) - Expecting PA 0x4F", test_num);
            reset_dut();
            virtual_address = 8'h3F;
            read_write = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h4F);
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
        $dumpvars(0,clk, read_write, reset, virtual_address, page_fault, physical_address);
    end

endmodule
