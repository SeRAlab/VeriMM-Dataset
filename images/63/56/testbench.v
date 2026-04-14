`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] direction;
    reg [3:0] floor_num;
    wire [2:0] floor_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direction(direction),
        .floor_num(floor_num),
        .floor_select(floor_select)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request Floor 0, Direction Up", test_num);
            floor_num = 4'b0001;
            direction = 2'b01;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request Floor 3, Direction Down", test_num);
            floor_num = 4'b1000;
            direction = 2'b10;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (0, 2), Direction Up -> Select Floor 2", test_num);
            floor_num = 4'b0101;
            direction = 2'b01;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (0, 2), Direction Down -> Select Floor 0", test_num);
            floor_num = 4'b0101;
            direction = 2'b10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (1, 2, 3), Direction Up -> Select Floor 3", test_num);
            floor_num = 4'b1110;
            direction = 2'b01;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (1, 2, 3), Direction Down -> Select Floor 1", test_num);
            floor_num = 4'b1110;
            direction = 2'b10;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No requests", test_num);
            floor_num = 4'b0000;
            direction = 2'b01;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request Floor 2, Direction Idle", test_num);
            floor_num = 4'b0100;
            direction = 2'b00;


            #1;



            check_outputs(3'b011);
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
        input [2:0] expected_floor_select;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_floor_select === (expected_floor_select ^ floor_select ^ expected_floor_select)) begin
                $display("PASS");
                $display("  Outputs: floor_select=%h",
                         floor_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: floor_select=%h",
                         expected_floor_select);
                $display("  Got:      floor_select=%h",
                         floor_select);
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
