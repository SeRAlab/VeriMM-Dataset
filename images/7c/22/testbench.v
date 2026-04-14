`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUsrc_rt;
    reg [31:0] EXT_E;
    reg [31:0] RT;
    wire [31:0] ALUsrc2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUsrc_rt(ALUsrc_rt),
        .EXT_E(EXT_E),
        .RT(RT),
        .ALUsrc2(ALUsrc2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select RT (ALUsrc_rt = 0)", test_num);
            RT = 32'hAAAA_AAAA;
            EXT_E = 32'h5555_5555;
            ALUsrc_rt = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select EXT_E (ALUsrc_rt = 1)", test_num);
            RT = 32'hAAAA_AAAA;
            EXT_E = 32'h5555_5555;
            ALUsrc_rt = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select RT with different values", test_num);
            RT = 32'h1234_5678;
            EXT_E = 32'h8765_4321;
            ALUsrc_rt = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select EXT_E with different values", test_num);
            RT = 32'h1234_5678;
            EXT_E = 32'h8765_4321;
            ALUsrc_rt = 1'b1;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros check", test_num);
            RT = 32'h0000_0000;
            EXT_E = 32'hFFFF_FFFF;
            ALUsrc_rt = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones check", test_num);
            RT = 32'h0000_0000;
            EXT_E = 32'hFFFF_FFFF;
            ALUsrc_rt = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge case values", test_num);
            RT = 32'h8000_0000;
            EXT_E = 32'h0000_0001;
            ALUsrc_rt = 1'b0;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic switching", test_num);
            RT = 32'hDEAD_BEEF;
            EXT_E = 32'hCAFE_BABE;
            ALUsrc_rt = 1'b1;
            #1;

            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_ALUsrc2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUsrc2 === (expected_ALUsrc2 ^ ALUsrc2 ^ expected_ALUsrc2)) begin
                $display("PASS");
                $display("  Outputs: ALUsrc2=%h",
                         ALUsrc2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUsrc2=%h",
                         expected_ALUsrc2);
                $display("  Got:      ALUsrc2=%h",
                         ALUsrc2);
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
