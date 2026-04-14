`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d_readdatain;
    wire [31:0] d_loadresult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_readdatain(d_readdatain),
        .d_loadresult(d_loadresult)
    );
    task testcase001;

    begin
        test_num = 1;
        d_readdatain = 32'h00000000;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        d_readdatain = 32'h7FFFFFFF;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        d_readdatain = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        d_readdatain = 32'h80000000;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        d_readdatain = 32'h00000080;


        #1;



        check_outputs(32'h00000080);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        d_readdatain = 32'h00008000;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        d_readdatain = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        d_readdatain = 32'h12345678;
        #1;

        check_outputs(32'h12345678);
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
        input [31:0] expected_d_loadresult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_loadresult === (expected_d_loadresult ^ d_loadresult ^ expected_d_loadresult)) begin
                $display("PASS");
                $display("  Outputs: d_loadresult=%h",
                         d_loadresult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_loadresult=%h",
                         expected_d_loadresult);
                $display("  Got:      d_loadresult=%h",
                         d_loadresult);
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
