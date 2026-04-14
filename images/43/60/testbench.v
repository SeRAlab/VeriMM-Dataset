`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] retdp_data_c7_buf;
    reg [27:0] retdp_ecc_c7_buf;
    wire [127:0] retdp_data_c7;
    wire [27:0] retdp_ecc_c7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .retdp_data_c7_buf(retdp_data_c7_buf),
        .retdp_ecc_c7_buf(retdp_ecc_c7_buf),
        .retdp_data_c7(retdp_data_c7),
        .retdp_ecc_c7(retdp_ecc_c7)
    );
    task testcase001;

        begin
            test_num = 1;
            retdp_data_c7_buf = 128'h0;
            retdp_ecc_c7_buf = 28'h0;
            $display("Test %0d: All Zeros Case", test_num);
            #1;

            check_outputs(128'h0, 28'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            retdp_data_c7_buf = {32{4'hF}};
            retdp_ecc_c7_buf = {7{4'hF}};
            $display("Test %0d: All Ones Case", test_num);
            #1;

            check_outputs({32{4'hF}}, {7{4'hF}});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            retdp_data_c7_buf = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            retdp_ecc_c7_buf = 28'hAAAAAAA;
            $display("Test %0d: Alternating Bits Pattern A", test_num);
            #1;

            check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, 28'hAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            retdp_data_c7_buf = 128'h55555555555555555555555555555555;
            retdp_ecc_c7_buf = 28'h5555555;
            $display("Test %0d: Alternating Bits Pattern 5", test_num);
            #1;

            check_outputs(128'h55555555555555555555555555555555, 28'h5555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            retdp_data_c7_buf = 128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF;
            retdp_ecc_c7_buf = 28'h7654321;
            $display("Test %0d: Random-style Hex Pattern", test_num);
            #1;

            check_outputs(128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF, 28'h7654321);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            retdp_data_c7_buf = (128'h1 << 127) | 128'h1;
            retdp_ecc_c7_buf = (28'h1 << 27) | 28'h1;
            $display("Test %0d: Boundary Bit Check", test_num);
            #1;

            check_outputs((128'h1 << 127) | 128'h1, (28'h1 << 27) | 28'h1);
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
        input [127:0] expected_retdp_data_c7;
        input [27:0] expected_retdp_ecc_c7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_retdp_data_c7 === (expected_retdp_data_c7 ^ retdp_data_c7 ^ expected_retdp_data_c7) &&
                expected_retdp_ecc_c7 === (expected_retdp_ecc_c7 ^ retdp_ecc_c7 ^ expected_retdp_ecc_c7)) begin
                $display("PASS");
                $display("  Outputs: retdp_data_c7=%h, retdp_ecc_c7=%h",
                         retdp_data_c7, retdp_ecc_c7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: retdp_data_c7=%h, retdp_ecc_c7=%h",
                         expected_retdp_data_c7, expected_retdp_ecc_c7);
                $display("  Got:      retdp_data_c7=%h, retdp_ecc_c7=%h",
                         retdp_data_c7, retdp_ecc_c7);
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
