`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] dir;
    reg [7:0] dir_ram;
    reg leer_ram;
    wire [7:0] d_ram;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .dir_ram(dir_ram),
        .leer_ram(leer_ram),
        .d_ram(d_ram)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: leer_ram = 1 (Select dir)", test_num);

        dir_ram = 8'hAA;
        dir = 8'h55;
        leer_ram = 1;

        @(posedge clk);

        #2;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: leer_ram = 0 (Select dir_ram)", test_num);
        dir_ram = 8'h12;
        dir = 8'h34;
        leer_ram = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Dynamic dir change with leer_ram = 1", test_num);
        leer_ram = 1;
        dir_ram = 8'h00;
        dir = 8'hFF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Dynamic dir_ram change with leer_ram = 0", test_num);
        leer_ram = 0;
        dir = 8'h00;
        dir_ram = 8'hCC;

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Switching leer_ram from 0 to 1", test_num);
        dir_ram = 8'hA1;
        dir = 8'hB2;
        leer_ram = 0;
        @(posedge clk);

        leer_ram = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hB2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify synchronous behavior (no change before clk)", test_num);

        leer_ram = 0;
        dir_ram = 8'h11;
        @(posedge clk);
        #2;


        dir_ram = 8'hEE;
        #1;

        if (d_ram === 8'h11) begin
            $display("PASS: Synchronous timing held");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Output changed asynchronously");
            fail_count = fail_count + 1;
        end

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hEE);
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
        input [7:0] expected_d_ram;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_ram === (expected_d_ram ^ d_ram ^ expected_d_ram)) begin
                $display("PASS");
                $display("  Outputs: d_ram=%h",
                         d_ram);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_ram=%h",
                         expected_d_ram);
                $display("  Got:      d_ram=%h",
                         d_ram);
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
