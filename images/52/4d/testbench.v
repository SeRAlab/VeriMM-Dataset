`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] mem_out;
    reg rst_n;
    wire [31:0] Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_out(mem_out),
        .rst_n(rst_n),
        .Data(Data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset to X", test_num);
            rst_n = 0;
            mem_out = 32'hDEADBEEF;
            #10;
            #1;

            check_outputs(32'hx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load All Zeros", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load All Ones", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load 0xAAAAAAAA", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'hAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load 0x55555555", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Load 0x12345678", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'h12345678;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Load 0xCAFEBABE", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'hCAFEBABE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Data Stability before Clock", test_num);
            rst_n = 0; #5;
            rst_n = 1;
            mem_out = 32'hABCDE123;
            @(posedge clk);
            #2;

            mem_out = 32'h00000000;
            #5;
            #1;

            check_outputs(32'hABCDE123);
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
        input [31:0] expected_Data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Data === (expected_Data ^ Data ^ expected_Data)) begin
                $display("PASS");
                $display("  Outputs: Data=%h",
                         Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data=%h",
                         expected_Data);
                $display("  Got:      Data=%h",
                         Data);
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
