`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] epc;
    reg [31:0] excepttype;
    reg [31:0] oldpc;
    wire [31:0] newpc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .epc(epc),
        .excepttype(excepttype),
        .oldpc(oldpc),
        .newpc(newpc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No exception (excepttype=0)", test_num);
        excepttype = 32'h00000000;
        oldpc = 32'h00001000;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00001000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Exception Type 1", test_num);
        excepttype = 32'h00000001;
        oldpc = 32'h00001004;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Exception Type 4", test_num);
        excepttype = 32'h00000004;
        oldpc = 32'h00001008;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Exception Type 5", test_num);
        excepttype = 32'h00000005;
        oldpc = 32'h0000100C;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Exception Type 8", test_num);
        excepttype = 32'h00000008;
        oldpc = 32'h00002000;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Exception Type 9", test_num);
        excepttype = 32'h00000009;
        oldpc = 32'h00002004;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Exception Type 10", test_num);
        excepttype = 32'h0000000A;
        oldpc = 32'h00002008;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Exception Type 12", test_num);
        excepttype = 32'h0000000C;
        oldpc = 32'h0000200C;
        epc   = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hBFC00380);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Exception Type 14 (EPC Update)", test_num);
        excepttype = 32'h0000000E;
        oldpc = 32'h00003000;
        epc   = 32'h87654321;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: No exception (type 0) verification", test_num);
        excepttype = 32'h00000000;
        oldpc = 32'hDEADBEEF;
        epc   = 32'h00000000;
        #1;

        check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_newpc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_newpc === (expected_newpc ^ newpc ^ expected_newpc)) begin
                $display("PASS");
                $display("  Outputs: newpc=%h",
                         newpc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: newpc=%h",
                         expected_newpc);
                $display("  Got:      newpc=%h",
                         newpc);
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
