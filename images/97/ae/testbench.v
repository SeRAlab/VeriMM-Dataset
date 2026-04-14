`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [3:0] in_data;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in_data(in_data),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Bitwise NOT (ctrl=00, data=1010)", test_num);
        ctrl = 2'b00;
        in_data = 4'b1010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Bitwise NOT (ctrl=00, data=0000)", test_num);
        ctrl = 2'b00;
        in_data = 4'b0000;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Two's Complement (ctrl=01, data=0011 [3])", test_num);
        ctrl = 2'b01;
        in_data = 4'b0011;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Two's Complement (ctrl=01, data=0000 [0])", test_num);
        ctrl = 2'b01;
        in_data = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Two's Complement (ctrl=01, data=1000 [-8])", test_num);
        ctrl = 2'b01;
        in_data = 4'b1000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Left Shift (ctrl=10, data=1011)", test_num);
        ctrl = 2'b10;
        in_data = 4'b1011;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Left Shift (ctrl=10, data=0001)", test_num);
        ctrl = 2'b10;
        in_data = 4'b0001;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Right Shift (ctrl=11, data=1101)", test_num);
        ctrl = 2'b11;
        in_data = 4'b1101;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Right Shift (ctrl=11, data=1000)", test_num);
        ctrl = 2'b11;
        in_data = 4'b1000;
        #1;

        check_outputs(4'b0100);
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
        input [3:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
