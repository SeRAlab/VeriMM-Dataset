`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [88:0] packet;
    wire [63:0] data;
    wire data_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .packet(packet),
        .data(data),
        .data_error(data_error)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Packet", test_num);
            packet = 89'h0;

            #1;


            check_outputs(64'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones Packet", test_num);
            packet = {89{1'b1}};

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 0xA5A5... Extraction", test_num);

            packet = {9'h1FF, 64'hA5A5A5A5A5A5A5A5, 16'h0000};
            #1;

            check_outputs(64'hA5A5A5A5A5A5A5A5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 0x1234... Extraction", test_num);

            packet = {9'h000, 64'h0123456789ABCDEF, 16'hFFFF};
            #1;

            check_outputs(64'h0123456789ABCDEF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Bit Check", test_num);


            packet = 89'h0;
            packet[16] = 1'b1;
            packet[79] = 1'b1;
            packet[15:0] = 16'hFFFF;
            packet[88:80] = 9'h1FF;

            #1;


            check_outputs(64'h8000000000000001, 1'b1);
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
        input [63:0] expected_data;
        input expected_data_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_data_error === (expected_data_error ^ data_error ^ expected_data_error)) begin
                $display("PASS");
                $display("  Outputs: data=%h, data_error=%b",
                         data, data_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, data_error=%b",
                         expected_data, expected_data_error);
                $display("  Got:      data=%h, data_error=%b",
                         data, data_error);
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
