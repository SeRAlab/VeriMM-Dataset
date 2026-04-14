`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    wire [31:0] inst_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .inst_out(inst_out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h0000_0000;
            $display("Test %0d: Accessing index 0 (Address 0x0)", test_num);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h0000_0004;
            $display("Test %0d: Accessing index 1 (Address 0x4)", test_num);

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h0000_003C;
            $display("Test %0d: Accessing index 15 (Address 0x3C)", test_num);
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h0000_007C;
            $display("Test %0d: Accessing index 31 (Address 0x7C)", test_num);
            #1;

            check_outputs(32'h0000001F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hFFFF_FF80;
            $display("Test %0d: Accessing index 0 with upper bits set (Address 0xFFFFFF80)", test_num);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h0000_007F;
            $display("Test %0d: Accessing index 31 with offset bits set (Address 0x7F)", test_num);

            #1;


            check_outputs(32'h0000001F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h0000_0008;
            $display("Test %0d: Sequential access (Address 0x8)", test_num);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h1234_5610;
            $display("Test %0d: High memory range (Address 0x12345610)", test_num);
            #1;

            check_outputs(32'h00000004);
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
        input [31:0] expected_inst_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inst_out === (expected_inst_out ^ inst_out ^ expected_inst_out)) begin
                $display("PASS");
                $display("  Outputs: inst_out=%h",
                         inst_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst_out=%h",
                         expected_inst_out);
                $display("  Got:      inst_out=%h",
                         inst_out);
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
