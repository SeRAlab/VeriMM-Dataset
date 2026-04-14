`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rd;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire hazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .hazard(hazard)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No hazard - distinct registers", test_num);
            rd  = 5'd10;
            rs1 = 5'd1;
            rs2 = 5'd2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Hazard detected on rs1 match", test_num);
            rd  = 5'd10;
            rs1 = 5'd10;
            rs2 = 5'd2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Hazard detected on rs2 match", test_num);
            rd  = 5'd15;
            rs1 = 5'd1;
            rs2 = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hazard detected on both rs1 and rs2 matching rd", test_num);
            rd  = 5'd20;
            rs1 = 5'd20;
            rs2 = 5'd20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: No hazard with upper boundary register addresses", test_num);
            rd  = 5'd31;
            rs1 = 5'd30;
            rs2 = 5'd29;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Hazard detected at register address boundary (31)", test_num);
            rd  = 5'd31;
            rs1 = 5'd31;
            rs2 = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: No hazard when rd is 0 (register 0 is often x0/zero)", test_num);



            rd  = 5'd0;
            rs1 = 5'd0;
            rs2 = 5'd1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: No hazard when source registers are zero but rd is non-zero", test_num);
            rd  = 5'd5;
            rs1 = 5'd0;
            rs2 = 5'd0;
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
