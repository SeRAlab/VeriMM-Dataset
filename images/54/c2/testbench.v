`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] address;
    reg [7:0] write_data;
    reg write_enable;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read at Address 0", test_num);

            address = 0;
            write_data = 0;
            write_enable = 0;
            #10;


            address = 4'h0;
            write_data = 8'hAA;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write and Read at different address (Address 15)", test_num);

            address = 0;
            write_data = 0;
            write_enable = 0;
            #10;


            address = 4'hF;
            write_data = 8'h55;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Write Enable (Attempt write when WE=0)", test_num);


            address = 4'h5;
            write_data = 8'h00;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;


            write_data = 8'hFF;
            write_enable = 0;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Overwrite Test", test_num);

            address = 4'h2;
            write_data = 8'h11;
            write_enable = 1;
            #10;


            write_data = 8'h22;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read/Write behavior (Continuous Read)", test_num);

            address = 4'hA;
            write_data = 8'h00;
            write_enable = 0;
            #10;


            write_data = 8'hC3;
            write_enable = 1;
            #5;

            #1;


            check_outputs(8'hC3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Persistence Check (Read back previously written value)", test_num);


            address = 4'hF;
            write_enable = 0;
            #10;


            address = 4'h0;
            #10;

            #1;


            check_outputs(8'hAA);
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
        input [7:0] expected_read_data;
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
