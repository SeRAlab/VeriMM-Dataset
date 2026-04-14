`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] imm12;
    wire [47:0] str;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm12(imm12),
        .str(str)
    );
    task testcase001;

    begin
        test_num = 1;
        imm12 = 12'h000;
        #10;

        #1;


        check_outputs("0x0000");
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        imm12 = 12'h00F;
        #10;
        #1;

        check_outputs("0x000F");
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        imm12 = 12'h123;
        #10;
        #1;

        check_outputs("0x0123");
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        imm12 = 12'hABC;
        #10;
        #1;

        check_outputs("0x0ABC");
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        imm12 = 12'h800;
        #10;
        #1;

        check_outputs("0x0800");
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        imm12 = 12'hFFF;
        #10;
        #1;

        check_outputs("0x0FFF");
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        imm12 = 12'h5D2;
        #10;
        #1;

        check_outputs("0x05D2");
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        imm12 = 12'hA0B;
        #10;
        #1;

        check_outputs("0x0A0B");
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
        input [47:0] expected_str;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_str === (expected_str ^ str ^ expected_str)) begin
                $display("PASS");
                $display("  Outputs: str=%h",
                         str);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: str=%h",
                         expected_str);
                $display("  Got:      str=%h",
                         str);
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
