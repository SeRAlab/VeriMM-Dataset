`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] inDataState;
    wire [127:0] outDataState;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inDataState(inDataState),
        .outDataState(outDataState)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            inDataState = 128'h0;

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            inDataState = {4{32'hFFFFFFFF}};


            #1;



            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Trigger A0 transformation", test_num);


            inDataState = 128'h00000000_FFFFFFFF_00000000_00000000;


            #1;



            check_outputs(128'h00000000_FFFFFFFF_00000000_FFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Trigger A1 transformation", test_num);

            inDataState = 128'hFFFFFFFF_00000000_00000000_00000000;


            #1;



            check_outputs(128'hFFFFFFFF_00000000_FFFFFFFF_00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise Mixed Patterns", test_num);

            inDataState = 128'hAAAAAAAA_55555555_CCCCCCCC_33333333;








            #1;









            check_outputs(128'hAAAAAAAA_55555555_66666666_22222222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify AND logic (Zeroing)", test_num);

            inDataState = 128'h00000000_FFFFFFFF_FFFFFFFF_00000000;


            #1;



            check_outputs(128'h00000000_FFFFFFFF_FFFFFFFF_00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify XOR logic (Nullification)", test_num);


            inDataState = 128'h00000000_55555555_00000000_55555555;


            #1;



            check_outputs(128'h00000000_55555555_00000000_00000000);
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
        input [127:0] expected_outDataState;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outDataState === (expected_outDataState ^ outDataState ^ expected_outDataState)) begin
                $display("PASS");
                $display("  Outputs: outDataState=%h",
                         outDataState);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outDataState=%h",
                         expected_outDataState);
                $display("  Got:      outDataState=%h",
                         outDataState);
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
