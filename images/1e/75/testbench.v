`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] opcode1;
    reg [2:0] opcode2;
    wire hazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .opcode1(opcode1),
        .opcode2(opcode2),
        .hazard(hazard)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identical Opcodes (000, 000)", test_num);
            opcode1 = 3'b000;
            opcode2 = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identical Opcodes - Load/Load (010, 010)", test_num);
            opcode1 = 3'b010;
            opcode2 = 3'b010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identical Opcodes - Store/Store (011, 011)", test_num);
            opcode1 = 3'b011;
            opcode2 = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identical Opcodes (111, 111)", test_num);
            opcode1 = 3'b111;
            opcode2 = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Load and Store pair (010, 011)", test_num);
            opcode1 = 3'b010;
            opcode2 = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Store and Load pair (011, 010)", test_num);
            opcode1 = 3'b011;
            opcode2 = 3'b010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No Hazard - Different opcodes (000, 001)", test_num);
            opcode1 = 3'b000;
            opcode2 = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No Hazard - Load with generic (010, 111)", test_num);
            opcode1 = 3'b010;
            opcode2 = 3'b111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No Hazard - Store with generic (011, 101)", test_num);
            opcode1 = 3'b011;
            opcode2 = 3'b101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No Hazard - Two generics (100, 101)", test_num);
            opcode1 = 3'b100;
            opcode2 = 3'b101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_hazard;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard === (expected_hazard ^ hazard ^ expected_hazard)) begin
                $display("PASS");
                $display("  Outputs: hazard=%b",
                         hazard);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard=%b",
                         expected_hazard);
                $display("  Got:      hazard=%b",
                         hazard);
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
