`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_num;
    wire [31:0] output_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_num(input_num),
        .output_num(output_num)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input all zeros", test_num);
        input_num = 32'h00000000;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input all ones", test_num);
        input_num = 32'hFFFFFFFF;
        #1;

        check_outputs(32'd32);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: LSB set", test_num);
        input_num = 32'h00000001;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MSB set", test_num);
        input_num = 32'h80000000;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bits 0x55555555", test_num);
        input_num = 32'h55555555;
        #1;

        check_outputs(32'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bits 0xAAAAAAAA", test_num);
        input_num = 32'hAAAAAAAA;
        #1;

        check_outputs(32'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower 16 bits set", test_num);
        input_num = 32'h0000FFFF;
        #1;

        check_outputs(32'd16);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Byte pattern 0xF0F0F0F0", test_num);
        input_num = 32'hF0F0F0F0;
        #1;

        check_outputs(32'd16);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed pattern 0x12345678", test_num);
        input_num = 32'h12345678;
        #1;

        check_outputs(32'd13);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed pattern 0xFEDCBA98", test_num);
        input_num = 32'hFEDCBA98;
        #1;

        check_outputs(32'd20);
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
        input [31:0] expected_output_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_num === (expected_output_num ^ output_num ^ expected_output_num)) begin
                $display("PASS");
                $display("  Outputs: output_num=%h",
                         output_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_num=%h",
                         expected_output_num);
                $display("  Got:      output_num=%h",
                         output_num);
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
