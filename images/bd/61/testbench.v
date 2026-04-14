`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] iDataALU;
    reg [7:0] iDataRAM;
    reg iRead;
    reg [7:0] iRegister;
    reg iWrite;
    wire [7:0] oRegister;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iDataALU(iDataALU),
        .iDataRAM(iDataRAM),
        .iRead(iRead),
        .iRegister(iRegister),
        .iWrite(iWrite),
        .oRegister(oRegister)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: iRead active, should output iDataRAM", test_num);
            iRead = 1;
            iWrite = 0;
            iDataRAM = 8'hA5;
            iDataALU = 8'h3C;
            iRegister = 8'h77;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: iWrite active, should output iDataALU", test_num);
            iRead = 0;
            iWrite = 1;
            iDataRAM = 8'h11;
            iDataALU = 8'hBB;
            iRegister = 8'h22;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Neither active, should output iRegister", test_num);
            iRead = 0;
            iWrite = 0;
            iDataRAM = 8'hAA;
            iDataALU = 8'hBB;
            iRegister = 8'hCC;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All data inputs zero, check default", test_num);
            iRead = 0;
            iWrite = 0;
            iDataRAM = 8'h00;
            iDataALU = 8'h00;
            iRegister = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values check (iRead high)", test_num);
            iRead = 1;
            iWrite = 0;
            iDataRAM = 8'hFF;
            iDataALU = 8'h00;
            iRegister = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both iRead and iWrite active (Assuming Read priority)", test_num);
            iRead = 1;
            iWrite = 1;
            iDataRAM = 8'h12;
            iDataALU = 8'h34;
            iRegister = 8'h56;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Register value update when idle", test_num);
            iRead = 0;
            iWrite = 0;
            iDataRAM = 8'h00;
            iDataALU = 8'h00;
            iRegister = 8'h5A;
            #1;

            check_outputs(8'h5A);
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
        input [7:0] expected_oRegister;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oRegister === (expected_oRegister ^ oRegister ^ expected_oRegister)) begin
                $display("PASS");
                $display("  Outputs: oRegister=%h",
                         oRegister);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRegister=%h",
                         expected_oRegister);
                $display("  Got:      oRegister=%h",
                         oRegister);
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
