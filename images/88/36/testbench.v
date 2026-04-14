`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] address;
    reg [7:0] data_in;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write and Read at Address 0x0000", test_num);
            address = 16'h0000;
            data_in = 8'hA5;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write and Read at Address 0x000F", test_num);
            address = 16'h000F;
            data_in = 8'h5A;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overwriting data at Address 0x0005", test_num);

            address = 16'h0005;
            data_in = 8'h11;
            write_en = 1;
            #10;

            data_in = 8'h99;
            #10;
            write_en = 0;
            #10;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying memory independence (Write A, Write B, Read A)", test_num);

            address = 16'h0001;
            data_in = 8'hDE;
            write_en = 1;
            #10;

            address = 16'h0002;
            data_in = 8'hAD;
            write_en = 1;
            #10;

            address = 16'h0001;
            write_en = 0;
            #10;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Writing all-ones (0xFF) to Address 0x000A", test_num);
            address = 16'h000A;
            data_in = 8'hFF;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Writing all-zeros (0x00) to Address 0x000E", test_num);
            address = 16'h000E;
            data_in = 8'h00;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
