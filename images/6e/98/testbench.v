`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg [4:0] shift_amount;
    wire [31:0] rotated_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .rotated_data(rotated_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Rotation", test_num);
            data_in = 32'h12345678;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift 1 bit left (wrapping bit)", test_num);
            data_in = 32'h80000001;
            shift_amount = 5'd1;

            #1;


            check_outputs(32'h00000003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift 4 bits left", test_num);
            data_in = 32'hABCDEF01;
            shift_amount = 5'd4;

            #1;


            check_outputs(32'hBCDEF01A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift 16 bits left (Half swap)", test_num);
            data_in = 32'hAAAA5555;
            shift_amount = 5'd16;

            #1;


            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift 31 bits left", test_num);
            data_in = 32'h00000001;
            shift_amount = 5'd31;


            #1;



            check_outputs(32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros input", test_num);
            data_in = 32'h00000000;
            shift_amount = 5'd13;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones input", test_num);
            data_in = 32'hFFFFFFFF;
            shift_amount = 5'd27;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrapping multiple bits", test_num);
            data_in = 32'hC0000000;
            shift_amount = 5'd2;

            #1;


            check_outputs(32'h00000003);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard rotation", test_num);
            data_in = 32'h55555555;
            shift_amount = 5'd1;

            #1;


            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex pattern rotation", test_num);
            data_in = 32'h12345678;
            shift_amount = 5'd8;

            #1;


            check_outputs(32'h34567812);
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
        input [31:0] expected_rotated_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rotated_data === (expected_rotated_data ^ rotated_data ^ expected_rotated_data)) begin
                $display("PASS");
                $display("  Outputs: rotated_data=%h",
                         rotated_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rotated_data=%h",
                         expected_rotated_data);
                $display("  Got:      rotated_data=%h",
                         rotated_data);
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
