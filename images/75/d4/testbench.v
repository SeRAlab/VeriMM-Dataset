`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control;
    reg [63:0] data_in;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Shift Left 1 bit (Control = 0)", test_num);
            data_in = 64'h8000000000000001;
            control = 4'd0;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift Right 1 bit (Control = 1)", test_num);
            data_in = 64'h8000000000000001;
            control = 4'd1;
            #1;

            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Left 2 bits (Control = 2)", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            control = 4'd2;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Right 2 bits (Control = 3)", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            control = 4'd3;
            #1;

            check_outputs(64'h3FFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Shift Left 3 bits (Control = 4)", test_num);
            data_in = 64'h000000000000000F;
            control = 4'd4;
            #1;

            check_outputs(64'h0000000000000078);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Shift Right 3 bits (Control = 5)", test_num);
            data_in = 64'hF000000000000000;
            control = 4'd5;
            #1;

            check_outputs(64'h1E00000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Shift Left 4 bits (Control = 6)", test_num);
            data_in = 64'hA5A5A5A5A5A5A5A5;
            control = 4'd6;
            #1;

            check_outputs(64'h5A5A5A5A5A5A5A50);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Shift Right 4 bits (Control = 7)", test_num);
            data_in = 64'hA5A5A5A5A5A5A5A5;
            control = 4'd7;
            #1;

            check_outputs(64'h0A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Control Out of Range (Control = 8)", test_num);
            data_in = 64'hFEDCBA9876543210;
            control = 4'd8;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Control Out of Range (Control = 15)", test_num);
            data_in = 64'h0123456789ABCDEF;
            control = 4'd15;
            #1;

            check_outputs(64'h0123456789ABCDEF);
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
        input [63:0] expected_data_out;
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
