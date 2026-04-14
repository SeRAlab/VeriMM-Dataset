`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [895:0] config_bits;
    reg [55:0] pterms_in;
    wire [15:0] or_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .config_bits(config_bits),
        .pterms_in(pterms_in),
        .or_out(or_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: All Zeros", test_num);
            pterms_in = 56'b0;
            config_bits = 896'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Test %03d: All Ones", test_num);
            pterms_in = 56'hFFFFFFFFFFFFFF;
            config_bits = {28{32'hFFFFFFFF}};
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: P-Terms Active, No Config", test_num);
            pterms_in = 56'hFFFFFFFFFFFFFF;
            config_bits = 896'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Config Active, No P-Terms", test_num);
            pterms_in = 56'b0;
            config_bits = {28{32'hFFFFFFFF}};
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Single Output (Bit 0) Configured", test_num);
            pterms_in = 56'h00000000000001;
            config_bits = 896'b0;
            config_bits[0] = 1'b1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Single Output (Bit 15) Configured", test_num);
            pterms_in = 56'h80000000000000;
            config_bits = 896'b0;
            config_bits[15*56 + 55] = 1'b1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Middle Output (Bit 8) with Mixed P-Terms", test_num);
            pterms_in = 56'h0000000000000F;
            config_bits = 896'b0;
            config_bits[8*56 + 3] = 1'b1;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Test %03d: Checkerboard Configuration", test_num);
            pterms_in = 56'hAAAAAAAAAAAAAAAA;
            config_bits = 896'b0;
            for(i=0; i<16; i=i+1) begin
                config_bits[i*56 + (i*2)] = 1'b1;
            end




            #1;





            check_outputs(16'h0000);
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
        input [15:0] expected_or_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_or_out === (expected_or_out ^ or_out ^ expected_or_out)) begin
                $display("PASS");
                $display("  Outputs: or_out=%h",
                         or_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: or_out=%h",
                         expected_or_out);
                $display("  Got:      or_out=%h",
                         or_out);
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
