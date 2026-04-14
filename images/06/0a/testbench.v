`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_MEM_reg;
    reg [4:0] MEM_WB_reg;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire forwardA;
    wire forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .EX_MEM_reg(EX_MEM_reg),
        .MEM_WB_reg(MEM_WB_reg),
        .rs1(rs1),
        .rs2(rs2),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No data hazards", test_num);
            rs1 = 5'd1;
            rs2 = 5'd2;
            EX_MEM_reg = 5'd3;
            MEM_WB_reg = 5'd4;

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: EX/MEM Hazard on rs1", test_num);
            rs1 = 5'd10;
            rs2 = 5'd5;
            EX_MEM_reg = 5'd10;
            MEM_WB_reg = 5'd3;

            #1;


            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: EX/MEM Hazard on rs2", test_num);
            rs1 = 5'd4;
            rs2 = 5'd12;
            EX_MEM_reg = 5'd12;
            MEM_WB_reg = 5'd2;

            #1;


            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM/WB Hazard on rs1", test_num);
            rs1 = 5'd15;
            rs2 = 5'd2;
            EX_MEM_reg = 5'd7;
            MEM_WB_reg = 5'd15;

            #1;


            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM/WB Hazard on rs2", test_num);
            rs1 = 5'd1;
            rs2 = 5'd20;
            EX_MEM_reg = 5'd8;
            MEM_WB_reg = 5'd20;

            #1;


            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Double Hazard on rs1 (Priority Check)", test_num);
            rs1 = 5'd25;
            rs2 = 5'd3;
            EX_MEM_reg = 5'd25;
            MEM_WB_reg = 5'd25;

            #1;


            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard on Register 0 (Should NOT forward)", test_num);
            rs1 = 5'd0;
            rs2 = 5'd0;
            EX_MEM_reg = 5'd0;
            MEM_WB_reg = 5'd0;

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed stage hazards on rs1 and rs2", test_num);
            rs1 = 5'd14;
            rs2 = 5'd16;
            EX_MEM_reg = 5'd14;
            MEM_WB_reg = 5'd16;

            #1;


            check_outputs(2'b10, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input expected_forwardA;
        input expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%b, forwardB=%b",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
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
