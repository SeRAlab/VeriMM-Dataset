`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] alu_cmd;
    reg [3:0] prio_cmd;
    reg [31:0] prio_data1;
    reg [31:0] prio_data2;
    wire [63:0] alu_data1;
    wire [63:0] alu_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_cmd(alu_cmd),
        .prio_cmd(prio_cmd),
        .prio_data1(prio_data1),
        .prio_data2(prio_data2),
        .alu_data1(alu_data1),
        .alu_data2(alu_data2)
    );
    task testcase001;

        begin
            test_num = 1;
            prio_data1 = 32'h00000000;
            prio_data2 = 32'h00000000;
            prio_cmd   = 4'h0;
            #10;
            $display("Testcase %0d: All zeros", test_num);
            if (alu_cmd !== prio_cmd) begin
                $display("  FAIL: alu_cmd expected %h, got %h", prio_cmd, alu_cmd);
            end
            #1;

            check_outputs(64'h00000000_00000000, 64'h00000000_00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            prio_data1 = 32'hFFFFFFFF;
            prio_data2 = 32'hFFFFFFFF;
            prio_cmd   = 4'hF;
            #10;
            $display("Testcase %0d: All ones", test_num);
            if (alu_cmd !== prio_cmd) begin
                $display("  FAIL: alu_cmd expected %h, got %h", prio_cmd, alu_cmd);
            end
            #1;

            check_outputs(64'hFFFFFFFF_00000000, 64'hFFFFFFFF_00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            prio_data1 = 32'hAAAAAAAA;
            prio_data2 = 32'h55555555;
            prio_cmd   = 4'hA;
            #10;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            if (alu_cmd !== prio_cmd) begin
                $display("  FAIL: alu_cmd expected %h, got %h", prio_cmd, alu_cmd);
            end
            #1;

            check_outputs(64'hAAAAAAAA_00000000, 64'h55555555_00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            prio_data1 = 32'h12345678;
            prio_data2 = 32'h9ABCDEF0;
            prio_cmd   = 4'h5;
            #10;
            $display("Testcase %0d: Specific hex patterns", test_num);
            if (alu_cmd !== prio_cmd) begin
                $display("  FAIL: alu_cmd expected %h, got %h", prio_cmd, alu_cmd);
            end
            #1;

            check_outputs(64'h12345678_00000000, 64'h9ABCDEF0_00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            prio_data1 = 32'h00000001;
            prio_data2 = 32'h80000000;
            prio_cmd   = 4'h7;
            #10;
            $display("Testcase %0d: Boundary bits (LSB and MSB)", test_num);
            if (alu_cmd !== prio_cmd) begin
                $display("  FAIL: alu_cmd expected %h, got %h", prio_cmd, alu_cmd);
            end
            #1;

            check_outputs(64'h00000001_00000000, 64'h80000000_00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            prio_data1 = 32'hDEADBEEF;
            prio_data2 = 32'hCAFEBABE;
            prio_cmd   = 4'hE;
            #10;
            $display("Testcase %0d: Complex data verification", test_num);
            if (alu_cmd !== prio_cmd) begin
                $display("  FAIL: alu_cmd expected %h, got %h", prio_cmd, alu_cmd);
            end
            #1;

            check_outputs(64'hDEADBEEF_00000000, 64'hCAFEBABE_00000000);
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
        input [63:0] expected_alu_data1;
        input [63:0] expected_alu_data2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_data1 === (expected_alu_data1 ^ alu_data1 ^ expected_alu_data1) &&
                expected_alu_data2 === (expected_alu_data2 ^ alu_data2 ^ expected_alu_data2)) begin
                $display("PASS");
                $display("  Outputs: alu_data1=%h, alu_data2=%h",
                         alu_data1, alu_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_data1=%h, alu_data2=%h",
                         expected_alu_data1, expected_alu_data2);
                $display("  Got:      alu_data1=%h, alu_data2=%h",
                         alu_data1, alu_data2);
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
