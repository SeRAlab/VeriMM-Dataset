`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] datain;
    reg [4:0] shftamt;
    reg shift_len;
    reg shift_ren;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain(datain),
        .shftamt(shftamt),
        .shift_len(shift_len),
        .shift_ren(shift_ren),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Shift (Both Control Signals Low)", test_num);
            datain = 32'hFFFFFFFF;
            shftamt = 5'd16;
            shift_len = 1'b0;
            shift_ren = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Left Shift by 4", test_num);
            datain = 32'h0000000F;
            shftamt = 5'd4;
            shift_len = 1'b1;
            shift_ren = 1'b0;
            #1;

            check_outputs(32'h000000F0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Right Shift by 4", test_num);
            datain = 32'hF0000000;
            shftamt = 5'd4;
            shift_len = 1'b0;
            shift_ren = 1'b1;
            #1;

            check_outputs(32'h0F000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift by 0", test_num);
            datain = 32'hA5A5A5A5;
            shftamt = 5'd0;
            shift_len = 1'b1;
            shift_ren = 1'b0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift by 0", test_num);
            datain = 32'h5A5A5A5A;
            shftamt = 5'd0;
            shift_len = 1'b0;
            shift_ren = 1'b1;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift by 31", test_num);
            datain = 32'h00000001;
            shftamt = 5'd31;
            shift_len = 1'b1;
            shift_ren = 1'b0;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift by 31", test_num);
            datain = 32'h80000000;
            shftamt = 5'd31;
            shift_len = 1'b0;
            shift_ren = 1'b1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift clearing lower bits", test_num);
            datain = 32'hFFFFFFFF;
            shftamt = 5'd16;
            shift_len = 1'b1;
            shift_ren = 1'b0;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift clearing upper bits", test_num);
            datain = 32'hFFFFFFFF;
            shftamt = 5'd16;
            shift_len = 1'b0;
            shift_ren = 1'b1;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift with data boundary 0x80...01", test_num);
            datain = 32'h80000001;
            shftamt = 5'd1;
            shift_len = 1'b1;
            shift_ren = 1'b0;
            #1;

            check_outputs(32'h00000002);
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
        input [31:0] expected_data_out;
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
