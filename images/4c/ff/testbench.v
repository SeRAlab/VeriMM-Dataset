`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Dataout;
    reg memtoreg;
    reg [31:0] result;
    wire [31:0] busW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Dataout(Dataout),
        .memtoreg(memtoreg),
        .result(result),
        .busW(busW)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select result (memtoreg=0)", test_num);
        result = 32'hAAAAAAAA;
        Dataout = 32'h55555555;
        memtoreg = 1'b0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Dataout (memtoreg=1)", test_num);
        result = 32'hAAAAAAAA;
        Dataout = 32'h55555555;
        memtoreg = 1'b1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros check", test_num);
        result = 32'h00000000;
        Dataout = 32'hFFFFFFFF;
        memtoreg = 1'b0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones check", test_num);
        result = 32'h00000000;
        Dataout = 32'hFFFFFFFF;
        memtoreg = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern bit-level check", test_num);
        result = 32'h12345678;
        Dataout = 32'h9ABCDEF0;
        memtoreg = 1'b0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle check", test_num);
        result = 32'hDEADBEEF;
        Dataout = 32'hCAFEBABE;
        memtoreg = 1'b1;
        #1;

        check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_busW;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busW === (expected_busW ^ busW ^ expected_busW)) begin
                $display("PASS");
                $display("  Outputs: busW=%h",
                         busW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busW=%h",
                         expected_busW);
                $display("  Got:      busW=%h",
                         busW);
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
