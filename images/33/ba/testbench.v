`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_instruction;
    reg [4:0] next_instruction;
    reg [4:0] writeback_instruction;
    wire hazard_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .current_instruction(current_instruction),
        .next_instruction(next_instruction),
        .writeback_instruction(writeback_instruction),
        .hazard_detected(hazard_detected)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No hazard (all instructions different registers)", test_num);
        current_instruction = 5'd10;
        next_instruction = 5'd11;
        writeback_instruction = 5'd12;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Hazard detected - current and next match", test_num);
        current_instruction = 5'd15;
        next_instruction = 5'd15;
        writeback_instruction = 5'd20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Hazard detected - current and writeback match", test_num);
        current_instruction = 5'd8;
        next_instruction = 5'd9;
        writeback_instruction = 5'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Hazard detected - all three registers match", test_num);
        current_instruction = 5'd25;
        next_instruction = 5'd25;
        writeback_instruction = 5'd25;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: No hazard - next and writeback match (current is different)", test_num);
        current_instruction = 5'd1;
        next_instruction = 5'd31;
        writeback_instruction = 5'd31;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Hazard detected - Register 0 (Boundary check)", test_num);
        current_instruction = 5'd0;
        next_instruction = 5'd0;
        writeback_instruction = 5'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Hazard detected - Max Register (Boundary check)", test_num);
        current_instruction = 5'd31;
        next_instruction = 5'd10;
        writeback_instruction = 5'd31;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: No hazard - adjacent registers", test_num);
        current_instruction = 5'd14;
        next_instruction = 5'd15;
        writeback_instruction = 5'd13;
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
        input expected_hazard_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard_detected === (expected_hazard_detected ^ hazard_detected ^ expected_hazard_detected)) begin
                $display("PASS");
                $display("  Outputs: hazard_detected=%b",
                         hazard_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard_detected=%b",
                         expected_hazard_detected);
                $display("  Got:      hazard_detected=%b",
                         hazard_detected);
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
