`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] xor_to_InvRows;
    wire [127:0] InvRows_to_InvSBox;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .xor_to_InvRows(xor_to_InvRows),
        .InvRows_to_InvSBox(InvRows_to_InvSBox)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (Identity Check)", test_num);
            xor_to_InvRows = 128'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Byte Pattern", test_num);

            xor_to_InvRows = 128'h000102030405060708090a0b0c0d0e0f;





            #1;






            check_outputs(128'h000d0a0704010e0b0805020f0c090603);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AES Standard Example Vector", test_num);

            xor_to_InvRows = 128'hbd6e7c3df2b5779e0b61216e8b10b689;
            #1;

            check_outputs(128'hbd10219ef26eb66e0bb57c898b61773d);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            xor_to_InvRows = 128'hffffffffffffffffffffffffffffffff;
            #1;

            check_outputs(128'hffffffffffffffffffffffffffffffff);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Byte Movement (Row 1)", test_num);


            xor_to_InvRows = 128'h00010000000000000000000000000000;
            #1;

            check_outputs(128'h00000000010000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Byte Movement (Row 2)", test_num);


            xor_to_InvRows = 128'h00000200000000000000000000000000;
            #1;

            check_outputs(128'h00000000000000000200000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Byte Movement (Row 3)", test_num);


            xor_to_InvRows = 128'h00000003000000000000000000000000;
            #1;

            check_outputs(128'h00000000000000030000000000000000);
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
        input [127:0] expected_InvRows_to_InvSBox;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_InvRows_to_InvSBox === (expected_InvRows_to_InvSBox ^ InvRows_to_InvSBox ^ expected_InvRows_to_InvSBox)) begin
                $display("PASS");
                $display("  Outputs: InvRows_to_InvSBox=%h",
                         InvRows_to_InvSBox);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InvRows_to_InvSBox=%h",
                         expected_InvRows_to_InvSBox);
                $display("  Got:      InvRows_to_InvSBox=%h",
                         InvRows_to_InvSBox);
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
