`timescale 1ns/1ps

module des_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [47:0] key;
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
            $display("Test Case %0d: All Zeros Input", test_num);


            data_in = 64'h00000000_00000000;
            key     = 48'h000000000000;


            #1;



            check_outputs(64'h00000000_E75D282A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            data_in = 64'hFFFFFFFF_FFFFFFFF;
            key     = 48'hFFFFFFFFFFFF;

            #1;


            check_outputs(64'hFFFFFFFF_7B521631);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (55AA)", test_num);
            data_in = 64'h55555555_AAAAAAAA;
            key     = 48'h555555555555;

            #1;


            check_outputs(64'hAAAAAAAA_1F2E3D4C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Round Vector", test_num);

            data_in = 64'h01234567_89ABCDEF;
            key     = 48'h13111D7FE394;

            #1;


            check_outputs(64'h89ABCDEF_DA7866FE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Sensitivity Test", test_num);

            data_in = 64'h01234567_89ABCDEF;
            key     = 48'h13111D7FE395;

            #1;


            check_outputs(64'h89ABCDEF_21B2A34F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Sensitivity Test", test_num);

            data_in = 64'h01234567_89ABCDEE;
            key     = 48'h13111D7FE394;

            #1;


            check_outputs(64'h89ABCDEE_9A8B7C6D);
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
