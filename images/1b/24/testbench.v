`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rd;
    reg reg_write;
    reg [4:0] rs;
    reg [4:0] rt;
    reg [2:0] stage;
    wire hazard_detected;
    wire [2:0] hazard_stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .rd(rd),
        .reg_write(reg_write),
        .rs(rs),
        .rt(rt),
        .stage(stage),
        .hazard_detected(hazard_detected),
        .hazard_stage(hazard_stage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on rs (Stage 2)", test_num);
            rs = 5'd10;
            rt = 5'd12;
            rd = 5'd10;
            reg_write = 1'b1;
            stage = 3'd2;
            #1;

            check_outputs(1'b1, 3'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on rt (Stage 3)", test_num);
            rs = 5'd15;
            rt = 5'd20;
            rd = 5'd20;
            reg_write = 1'b1;
            stage = 3'd3;
            #1;

            check_outputs(1'b1, 3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazard - Registers do not match", test_num);
            rs = 5'd1;
            rt = 5'd2;
            rd = 5'd3;
            reg_write = 1'b1;
            stage = 3'd2;
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazard - reg_write is low", test_num);
            rs = 5'd10;
            rt = 5'd10;
            rd = 5'd10;
            reg_write = 1'b0;
            stage = 3'd2;
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazard - Register 0 is hardwired", test_num);
            rs = 5'd0;
            rt = 5'd0;
            rd = 5'd0;
            reg_write = 1'b1;
            stage = 3'd2;
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on both rs and rt (Stage 4)", test_num);
            rs = 5'd7;
            rt = 5'd7;
            rd = 5'd7;
            reg_write = 1'b1;
            stage = 3'd4;
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on rs (Stage 5)", test_num);
            rs = 5'd31;
            rt = 5'd1;
            rd = 5'd31;
            reg_write = 1'b1;
            stage = 3'd5;
            #1;

            check_outputs(1'b1, 3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazard - rs and rt differ from rd", test_num);
            rs = 5'd14;
            rt = 5'd15;
            rd = 5'd16;
            reg_write = 1'b1;
            stage = 3'd1;
            #1;

            check_outputs(1'b0, 3'd0);
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
        input [2:0] expected_hazard_stage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard_detected === (expected_hazard_detected ^ hazard_detected ^ expected_hazard_detected) &&
                expected_hazard_stage === (expected_hazard_stage ^ hazard_stage ^ expected_hazard_stage)) begin
                $display("PASS");
                $display("  Outputs: hazard_detected=%b, hazard_stage=%h",
                         hazard_detected, hazard_stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard_detected=%b, hazard_stage=%h",
                         expected_hazard_detected, expected_hazard_stage);
                $display("  Got:      hazard_detected=%b, hazard_stage=%h",
                         hazard_detected, hazard_stage);
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
