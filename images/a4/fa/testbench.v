`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d;
    wire [4:0] clz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .clz(clz)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: All bits high", test_num);
        d = 32'hFFFFFFFF;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Only MSB high (Bit 31)", test_num);
        d = 32'h80000000;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Bit 30 high", test_num);
        d = 32'h40000000;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Bit 16 high (Middle)", test_num);
        d = 32'h00010000;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Only LSB high (Bit 0)", test_num);
        d = 32'h00000001;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: All zeros (Overflow case 32->0)", test_num);
        d = 32'h00000000;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Value 0x0000000F", test_num);
        d = 32'h0000000F;
        #1;

        check_outputs(5'd28);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: Value 0x00000800", test_num);
        d = 32'h00000800;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %03d: Value 0x00F01234", test_num);
        d = 32'h00F01234;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %03d: Value 0x1FFFFFFF", test_num);
        d = 32'h1FFFFFFF;
        #1;

        check_outputs(5'd3);
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
        input [4:0] expected_clz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clz === (expected_clz ^ clz ^ expected_clz)) begin
                $display("PASS");
                $display("  Outputs: clz=%h",
                         clz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clz=%h",
                         expected_clz);
                $display("  Got:      clz=%h",
                         clz);
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
