`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] inword;
    reg [2:0] sel;
    wire [7:0] outbyte;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inword(inword),
        .sel(sel),
        .outbyte(outbyte)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Byte 0", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd0;
        #1;

        check_outputs(8'hEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Byte 1", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd1;
        #1;

        check_outputs(8'hCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Byte 2", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd2;
        #1;

        check_outputs(8'hAB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Byte 3", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd3;
        #1;

        check_outputs(8'h89);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select Byte 4", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd4;
        #1;

        check_outputs(8'h67);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select Byte 5", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd5;
        #1;

        check_outputs(8'h45);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select Byte 6", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd6;
        #1;

        check_outputs(8'h23);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select Byte 7", test_num);
        inword = 64'h0123456789ABCDEF;
        sel = 3'd7;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: All bits high", test_num);
        inword = 64'hFFFFFFFFFFFFFFFF;
        sel = 3'd4;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: All bits low", test_num);
        inword = 64'h0000000000000000;
        sel = 3'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %0d: Random pattern", test_num);
        inword = 64'hA55A1234BEEFCAFE;
        sel = 3'd1;
        #1;

        check_outputs(8'hCA);
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
        testcase011();
        
        
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
        input [7:0] expected_outbyte;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outbyte === (expected_outbyte ^ outbyte ^ expected_outbyte)) begin
                $display("PASS");
                $display("  Outputs: outbyte=%h",
                         outbyte);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outbyte=%h",
                         expected_outbyte);
                $display("  Got:      outbyte=%h",
                         outbyte);
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
