`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] checksum_in;
    reg [7:0] data_in;
    wire valid_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .checksum_in(checksum_in),
        .data_in(data_in),
        .valid_data(valid_data)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 8'h00;
        checksum_in = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 8'h01;
        checksum_in = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 8'h01;
        checksum_in = 8'h01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 8'hFF;
        checksum_in = 8'h01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 8'h80;
        checksum_in = 8'h80;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 8'h55;
        checksum_in = 8'hAB;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 8'hAA;
        checksum_in = 8'h56;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 8'h12;
        checksum_in = 8'hEE;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 8'h12;
        checksum_in = 8'hED;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 8'h7F;
        checksum_in = 8'h81;
        #1;

        check_outputs(1'b1);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_valid_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid_data === (expected_valid_data ^ valid_data ^ expected_valid_data)) begin
                $display("PASS");
                $display("  Outputs: valid_data=%b",
                         valid_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_data=%b",
                         expected_valid_data);
                $display("  Got:      valid_data=%b",
                         valid_data);
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
