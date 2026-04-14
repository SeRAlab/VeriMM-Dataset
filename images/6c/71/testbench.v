`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [159:0] hash_state_in;
    reg [6:0] round;
    reg [31:0] w;
    wire [159:0] hash_state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hash_state_in(hash_state_in),
        .round(round),
        .w(w),
        .hash_state_out(hash_state_out)
    );
    task testcase001;

        begin
            test_num = 1;
            hash_state_in = 160'h67452301_EFCDAB89_98BADCFE_10325476_C3D2E1F0;
            round = 7'd0;
            w = 32'h00000000;


            #1;



            check_outputs(160'h9FB598B3_67452301_7BF36AE2_98BADCFE_10325476);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            hash_state_in = 160'h00000001_00000002_00000004_00000008_00000010;
            round = 7'd20;
            w = 32'h00000000;


            #1;



            check_outputs(160'h6ED9EBCF_00000001_80000000_00000004_00000008);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            hash_state_in = 160'h00000001_00000002_00000004_00000008_00000010;
            round = 7'd40;
            w = 32'h00000000;


            #1;



            check_outputs(160'h8F1BBD0C_00000001_80000000_00000004_00000008);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            hash_state_in = 160'h00000001_00000002_00000004_00000008_00000010;
            round = 7'd60;
            w = 32'h00000000;


            #1;



            check_outputs(160'hCA62C204_00000001_80000000_00000004_00000008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            hash_state_in = 160'hAAAAAAAA_BBBBBBBB_CCCCCCCC_DDDDDDDD_EEEEEEEE;
            round = 7'd0;
            w = 32'h12345678;



            #1;




            check_outputs(160'h7DC7E120_AAAAAAAA_EEEEEEEE_CCCCCCCC_DDDDDDDD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            hash_state_in = 160'h00000001_00000002_00000004_00000008_00000010;
            round = 7'd19;
            w = 32'h00000000;


            #1;



            check_outputs(160'h5A8279CF_00000001_80000000_00000004_00000008);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            hash_state_in = 160'h00000001_00000002_00000004_00000008_00000010;
            round = 7'd39;
            w = 32'h00000000;


            #1;



            check_outputs(160'h6ED9EBCF_00000001_80000000_00000004_00000008);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            hash_state_in = 160'h00000001_00000002_00000004_00000008_00000010;
            round = 7'd59;
            w = 32'h00000000;


            #1;



            check_outputs(160'h8F1BBD0C_00000001_80000000_00000004_00000008);
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
        input [159:0] expected_hash_state_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash_state_out === (expected_hash_state_out ^ hash_state_out ^ expected_hash_state_out)) begin
                $display("PASS");
                $display("  Outputs: hash_state_out=%h",
                         hash_state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_state_out=%h",
                         expected_hash_state_out);
                $display("  Got:      hash_state_out=%h",
                         hash_state_out);
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
