`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_reg;
    reg [4:0] src_reg_1;
    reg [4:0] src_reg_2;
    wire hazard_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .dest_reg(dest_reg),
        .src_reg_1(src_reg_1),
        .src_reg_2(src_reg_2),
        .hazard_detected(hazard_detected)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No match between destination and source registers", test_num);
        dest_reg = 5'd10;
        src_reg_1 = 5'd5;
        src_reg_2 = 5'd3;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hazard match on src_reg_1", test_num);
        dest_reg = 5'd15;
        src_reg_1 = 5'd15;
        src_reg_2 = 5'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hazard match on src_reg_2", test_num);
        dest_reg = 5'd20;
        src_reg_1 = 5'd1;
        src_reg_2 = 5'd20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hazard match on both source registers", test_num);
        dest_reg = 5'd31;
        src_reg_1 = 5'd31;
        src_reg_2 = 5'd31;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Handling of Register 0 (Architectural edge case)", test_num);
        dest_reg = 5'd0;
        src_reg_1 = 5'd0;
        src_reg_2 = 5'd0;






        #1;







        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Toggle high-order bits", test_num);
        dest_reg = 5'b10000;
        src_reg_1 = 5'b10000;
        src_reg_2 = 5'b00001;
        #1;

        check_outputs(1'b1);
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
