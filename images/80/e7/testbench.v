`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] sh_a;
    wire [7:0] sh_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sh_a(sh_a),
        .sh_y(sh_y)
    );
    task testcase001;

    begin
        test_num = 1;
        sh_a = 32'h00000000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        sh_a = 32'hFFFFFFFF;
        #1;

        check_outputs(8'hFC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        sh_a = 32'h00000003;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        sh_a = 32'h00000004;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        sh_a = 32'h00000080;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        sh_a = 32'hFFFFF100;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;


        sh_a = 32'h000000AA;
        #1;

        check_outputs(8'hA8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;


        sh_a = 32'h00000055;
        #1;

        check_outputs(8'h54);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;


        sh_a = 32'h1234567B;
        #1;

        check_outputs(8'h78);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;


        sh_a = 32'h00000087;
        #1;

        check_outputs(8'h84);
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
        input [7:0] expected_sh_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sh_y === (expected_sh_y ^ sh_y ^ expected_sh_y)) begin
                $display("PASS");
                $display("  Outputs: sh_y=%h",
                         sh_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sh_y=%h",
                         expected_sh_y);
                $display("  Got:      sh_y=%h",
                         sh_y);
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
