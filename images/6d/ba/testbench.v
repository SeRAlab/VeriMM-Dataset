`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1023:0] key_constant_i;
    reg [1023:0] key_register_i;
    reg mode_i;
    wire [1023:0] key_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key_constant_i(key_constant_i),
        .key_register_i(key_register_i),
        .mode_i(mode_i),
        .key_o(key_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Select key_constant_i (mode_i = 0)", test_num);
            mode_i = 1'b0;
            key_constant_i = {128{8'hAA}};
            key_register_i = {128{8'h55}};
            #1;

            check_outputs({128{8'hAA}});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Select key_register_i (mode_i = 1)", test_num);
            mode_i = 1'b1;
            key_constant_i = {128{8'hAA}};
            key_register_i = {128{8'h55}};
            #1;

            check_outputs({128{8'h55}});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All zeros check (mode_i = 0)", test_num);
            mode_i = 1'b0;
            key_constant_i = 1024'h0;
            key_register_i = {128{8'hFF}};
            #1;

            check_outputs(1024'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All ones check (mode_i = 1)", test_num);
            mode_i = 1'b1;
            key_constant_i = 1024'h0;
            key_register_i = {128{8'hFF}};
            #1;

            check_outputs({128{8'hFF}});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Incremental pattern check (mode_i = 0)", test_num);
            mode_i = 1'b0;

            key_constant_i = {32{32'hDEADBEEF}};
            key_register_i = {32{32'hCAFEBABE}};
            #1;

            check_outputs({32{32'hDEADBEEF}});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Incremental pattern check (mode_i = 1)", test_num);
            mode_i = 1'b1;
            key_constant_i = {32{32'hDEADBEEF}};
            key_register_i = {32{32'hCAFEBABE}};
            #1;

            check_outputs({32{32'hCAFEBABE}});
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
        input [1023:0] expected_key_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_key_o === (expected_key_o ^ key_o ^ expected_key_o)) begin
                $display("PASS");
                $display("  Outputs: key_o=%h",
                         key_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_o=%h",
                         expected_key_o);
                $display("  Got:      key_o=%h",
                         key_o);
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
