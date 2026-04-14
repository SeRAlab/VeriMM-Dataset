`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] address;
    reg mem_read;
    reg mem_write;
    reg [63:0] write_data;
    wire [63:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .write_data(write_data),
        .read_data(read_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Write and Read at Address 0", test_num);

            address = 7'd0;
            write_data = 64'h1122334455667788;
            mem_write = 0;
            mem_read = 0;
            #5;


            mem_write = 1;
            #10;
            mem_write = 0;
            #5;


            mem_read = 1;
            #5;
            #1;

            check_outputs(64'h1122334455667788);
            mem_read = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write and Read at Max Address (127)", test_num);

            address = 7'd127;
            write_data = 64'hFEDCBA9876543210;
            mem_write = 0;
            mem_read = 0;
            #5;


            mem_write = 1;
            #10;
            mem_write = 0;
            #5;


            mem_read = 1;
            #5;
            #1;

            check_outputs(64'hFEDCBA9876543210);
            mem_read = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Overwriting an existing memory location", test_num);

            address = 7'd64;
            write_data = 64'hAAAAAAAAAAAAAAAA;
            mem_write = 1;
            #10;
            mem_write = 0;
            #5;


            write_data = 64'h5555555555555555;
            mem_write = 1;
            #10;
            mem_write = 0;
            #5;


            mem_read = 1;
            #5;
            #1;

            check_outputs(64'h5555555555555555);
            mem_read = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Multiple writes, ensuring address isolation", test_num);

            address = 7'd10;
            write_data = 64'h000000000000000A;
            mem_write = 1;
            #10;

            address = 7'd11;
            write_data = 64'h000000000000000B;
            #10;
            mem_write = 0;
            #5;


            address = 7'd10;
            mem_read = 1;
            #5;
            #1;

            check_outputs(64'h000000000000000A);
            mem_read = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data with all bits set", test_num);
            address = 7'd42;
            write_data = 64'hFFFFFFFFFFFFFFFF;
            mem_write = 1;
            #10;
            mem_write = 0;
            #5;

            mem_read = 1;
            #5;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
            mem_read = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [63:0] expected_read_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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

endmodule
