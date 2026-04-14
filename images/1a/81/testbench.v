`timescale 1ns/1ps

module des_one_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [55:0] key;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_one_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input and Key", test_num);
            data_in = 64'h00000000_00000000;
            key     = 56'h00000000_000000;


            #1;



            check_outputs(64'h00000000_DA02CE3A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Hex Pattern", test_num);
            data_in = 64'h01234567_89ABCDEF;
            key     = 56'h133457_799BBCDF;


            #1;



            check_outputs(64'h89ABCDEF_0E815505);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Data and Key", test_num);
            data_in = 64'hFFFFFFFF_FFFFFFFF;
            key     = 56'hFFFFFF_FFFFFF;


            #1;



            check_outputs(64'hFFFFFFFF_320A000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern", test_num);
            data_in = 64'h55555555_AAAAAAAA;
            key     = 56'hAAAAAA_AAAAAA;

            #1;


            check_outputs(64'hAAAAAAAA_1267D974);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Sensitivity (Single Bit Change)", test_num);
            data_in = 64'h00000000_00000000;
            key     = 56'h000000_000001;

            #1;


            check_outputs(64'h00000000_D202CE3A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Feistel Structure Consistency", test_num);
            data_in = 64'hABCDEF01_00000000;
            key     = 56'h000000_000000;

            #1;


            check_outputs(64'h00000000_71CD213B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_one_round Testbench");
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
