`timescale 1ns/1ps

module des_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [55:0] key;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            data_in = 64'h0000000000000000;
            key     = 56'h00000000000000;


            #1;



            check_outputs(64'hDA02CE3A89BF8441);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            key     = 56'hFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'h15FB82E56A0C2C39);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (5/A)", test_num);
            data_in = 64'h5555555555555555;
            key     = 56'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(64'hA48B22C9C61389D2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard DES Test Vector Pattern", test_num);
            data_in = 64'h0123456789ABCDEF;
            key     = 56'h133457799BBCDF;
            #1;

            check_outputs(64'h7D332A02C130E0BD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Sensitivity Check", test_num);

            data_in = 64'h0123456789ABCDEF;
            key     = 56'hFEDCBA98765432;
            #1;

            check_outputs(64'h2B5C19A0F0D1E2A3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex Pattern", test_num);
            data_in = 64'hDEADBEEFCAFEBABE;
            key     = 56'h01020304050607;
            #1;

            check_outputs(64'h9E1D2C3B4A596877);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_round Testbench");
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
