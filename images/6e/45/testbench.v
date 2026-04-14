`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] px;
    reg [9:0] py;
    wire [11:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .px(px),
        .py(py),
        .rgb(rgb)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Outside the area (Top-Left)", test_num);
        px = 10'd50;
        py = 10'd50;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Top-Left corner border", test_num);
        px = 10'd100;
        py = 10'd100;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Middle of Top border", test_num);
        px = 10'd150;
        py = 10'd100;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Middle of Left border", test_num);
        px = 10'd100;
        py = 10'd150;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Inside the rectangle (not border)", test_num);
        px = 10'd150;
        py = 10'd150;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Bottom-Right corner border", test_num);
        px = 10'd200;
        py = 10'd200;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Just outside the Right border", test_num);
        px = 10'd201;
        py = 10'd150;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Just outside the Bottom border", test_num);
        px = 10'd150;
        py = 10'd201;
        #1;

        check_outputs(12'h000);
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
        input [11:0] expected_rgb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
