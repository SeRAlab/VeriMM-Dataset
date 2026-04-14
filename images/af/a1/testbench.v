`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] I26;
    reg NPCsrc;
    reg [31:0] PC4;
    wire [31:0] NPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I26(I26),
        .NPCsrc(NPCsrc),
        .PC4(PC4),
        .NPC(NPC)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Jump Mode - Basic", test_num);
            NPCsrc = 1;
            PC4 = 32'h1000_0000;
            I26 = 26'h000_0001;
            #1;

            check_outputs(32'h1000_0004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Jump Mode - Max I26 and high PC4", test_num);
            NPCsrc = 1;
            PC4 = 32'hF000_0000;
            I26 = 26'h3FF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Jump Mode - PC4 upper bits preservation", test_num);
            NPCsrc = 1;
            PC4 = 32'hA5A5_A5A5;
            I26 = 26'h123_4567;
            #1;

            check_outputs({4'hA, 26'h123_4567, 2'b00});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Branch Mode - Positive Offset", test_num);
            NPCsrc = 0;
            PC4 = 32'h0000_1000;
            I26 = 26'h000_0004;

            #1;


            check_outputs(32'h0000_1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Branch Mode - Negative Offset", test_num);
            NPCsrc = 0;
            PC4 = 32'h0000_1000;
            I26 = 26'h000_FFFF;

            #1;


            check_outputs(32'h0000_0FFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Branch Mode - Zero Offset", test_num);
            NPCsrc = 0;
            PC4 = 32'h1234_5678;
            I26 = 26'h000_0000;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Branch Mode - Max Positive Offset", test_num);
            NPCsrc = 0;
            PC4 = 32'h0000_0000;
            I26 = 26'h000_7FFF;

            #1;


            check_outputs(32'h0001_FFFC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Branch Mode - Max Negative Offset", test_num);
            NPCsrc = 0;
            PC4 = 32'h0002_0000;
            I26 = 26'h000_8000;


            #1;



            check_outputs(32'h0000_0000);
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
        input [31:0] expected_NPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NPC === (expected_NPC ^ NPC ^ expected_NPC)) begin
                $display("PASS");
                $display("  Outputs: NPC=%h",
                         NPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NPC=%h",
                         expected_NPC);
                $display("  Got:      NPC=%h",
                         NPC);
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
