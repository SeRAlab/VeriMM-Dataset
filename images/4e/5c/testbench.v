`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input16;
    wire [7:0] output8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input16(input16),
        .output8(output8)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros (0 + 0)", test_num);
        input16 = 16'h0000;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple addition without carry (10 + 20)", test_num);
        input16 = 16'h0A14;

        #1;


        check_outputs(8'h1E);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition resulting in 255 (0xAA + 0x55)", test_num);
        input16 = 16'hAA55;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with overflow (255 + 1)", test_num);
        input16 = 16'hFF01;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with overflow (128 + 128)", test_num);
        input16 = 16'h8080;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values (255 + 255)", test_num);
        input16 = 16'hFFFF;

        #1;


        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Higher half only", test_num);
        input16 = 16'h1200;

        #1;


        check_outputs(8'h12);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lower half only", test_num);
        input16 = 16'h0034;

        #1;


        check_outputs(8'h34);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary addition (0x12 + 0x34)", test_num);
        input16 = 16'h1234;

        #1;


        check_outputs(8'h46);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow with large numbers (0x81 + 0x81)", test_num);
        input16 = 16'h8181;

        #1;


        check_outputs(8'h02);
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
        input [7:0] expected_output8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output8 === (expected_output8 ^ output8 ^ expected_output8)) begin
                $display("PASS");
                $display("  Outputs: output8=%h",
                         output8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output8=%h",
                         expected_output8);
                $display("  Got:      output8=%h",
                         output8);
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
