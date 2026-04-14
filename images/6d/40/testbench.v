`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] endianswapper_01acfc81_in;
    wire [31:0] endianswapper_01acfc81_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .endianswapper_01acfc81_in(endianswapper_01acfc81_in),
        .endianswapper_01acfc81_out(endianswapper_01acfc81_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros input", test_num);
        endianswapper_01acfc81_in = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All ones input", test_num);
        endianswapper_01acfc81_in = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Sequential byte pattern (0x12345678)", test_num);
        endianswapper_01acfc81_in = 32'h12345678;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Alternating bit pattern (0xAAAAAAAA)", test_num);
        endianswapper_01acfc81_in = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bit pattern (0x55555555)", test_num);
        endianswapper_01acfc81_in = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Nibble pattern (0xA5B6C7D8)", test_num);
        endianswapper_01acfc81_in = 32'hA5B6C7D8;
        #1;

        check_outputs(32'hA5B6C7D8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Single bit set MSB", test_num);
        endianswapper_01acfc81_in = 32'h80000000;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Single bit set LSB", test_num);
        endianswapper_01acfc81_in = 32'h00000001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Reverse sequential byte pattern", test_num);
        endianswapper_01acfc81_in = 32'h87654321;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Boundary pattern", test_num);
        endianswapper_01acfc81_in = 32'hFF00FF00;
        #1;

        check_outputs(32'hFF00FF00);
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
        input [31:0] expected_endianswapper_01acfc81_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_endianswapper_01acfc81_out === (expected_endianswapper_01acfc81_out ^ endianswapper_01acfc81_out ^ expected_endianswapper_01acfc81_out)) begin
                $display("PASS");
                $display("  Outputs: endianswapper_01acfc81_out=%h",
                         endianswapper_01acfc81_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: endianswapper_01acfc81_out=%h",
                         expected_endianswapper_01acfc81_out);
                $display("  Got:      endianswapper_01acfc81_out=%h",
                         endianswapper_01acfc81_out);
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
