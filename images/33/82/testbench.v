`timescale 1ns/1ps

module DataForwardingUnit_tb;

    // Testbench signals (combinational circuit)
    reg EX_valid;
    reg MEM_valid;
    reg [4:0] rd_EX;
    reg [4:0] rd_MEM;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DataForwardingUnit dut (
        .EX_valid(EX_valid),
        .MEM_valid(MEM_valid),
        .rd_EX(rd_EX),
        .rd_MEM(rd_MEM),
        .rs1(rs1),
        .rs2(rs2),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No Hazard", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b1;
            rd_EX = 5'd10;
            rd_MEM = 5'd11;
            rs1 = 5'd1;
            rs2 = 5'd2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: EX Hazard on RS1", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b0;
            rd_EX = 5'd5;
            rd_MEM = 5'd0;
            rs1 = 5'd5;
            rs2 = 5'd2;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: EX Hazard on RS2", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b0;
            rd_EX = 5'd8;
            rd_MEM = 5'd0;
            rs1 = 5'd1;
            rs2 = 5'd8;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: MEM Hazard on RS1", test_num);
            EX_valid = 1'b0;
            MEM_valid = 1'b1;
            rd_EX = 5'd0;
            rd_MEM = 5'd15;
            rs1 = 5'd15;
            rs2 = 5'd2;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: MEM Hazard on RS2", test_num);
            EX_valid = 1'b0;
            MEM_valid = 1'b1;
            rd_EX = 5'd0;
            rd_MEM = 5'd20;
            rs1 = 5'd1;
            rs2 = 5'd20;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority Hazard (EX and MEM) on RS1", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b1;
            rd_EX = 5'd7;
            rd_MEM = 5'd7;
            rs1 = 5'd7;
            rs2 = 5'd2;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed Hazards (RS1-EX, RS2-MEM)", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b1;
            rd_EX = 5'd12;
            rd_MEM = 5'd13;
            rs1 = 5'd12;
            rs2 = 5'd13;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: EX Valid Signal Gating", test_num);
            EX_valid = 1'b0;
            MEM_valid = 1'b1;
            rd_EX = 5'd25;
            rd_MEM = 5'd0;
            rs1 = 5'd25;
            rs2 = 5'd2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: MEM Valid Signal Gating", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b0;
            rd_EX = 5'd0;
            rd_MEM = 5'd30;
            rs1 = 5'd1;
            rs2 = 5'd30;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Simultaneous EX/MEM swaps", test_num);
            EX_valid = 1'b1;
            MEM_valid = 1'b1;
            rd_EX = 5'd2;
            rd_MEM = 5'd1;
            rs1 = 5'd1;
            rs2 = 5'd2;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DataForwardingUnit Testbench");
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
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%h, forwardB=%h",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%h, forwardB=%h",
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
