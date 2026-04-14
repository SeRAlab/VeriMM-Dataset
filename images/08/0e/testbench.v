`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_reg_MEM;
    reg [4:0] dest_reg_WB;
    reg reg_write_MEM;
    reg reg_write_WB;
    reg [4:0] src_reg_EX;
    wire forwardA;
    wire forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .dest_reg_MEM(dest_reg_MEM),
        .dest_reg_WB(dest_reg_WB),
        .reg_write_MEM(reg_write_MEM),
        .reg_write_WB(reg_write_WB),
        .src_reg_EX(src_reg_EX),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

        begin
            $display("Testcase 001: No hazards");
            test_num = test_num + 1;
            src_reg_EX = 5'd10;
            dest_reg_MEM = 5'd11;
            dest_reg_WB = 5'd12;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: MEM Stage Hazard (forwardA)");
            test_num = test_num + 1;
            src_reg_EX = 5'd5;
            dest_reg_MEM = 5'd5;
            dest_reg_WB = 5'd10;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: WB Stage Hazard (forwardB)");
            test_num = test_num + 1;
            src_reg_EX = 5'd5;
            dest_reg_MEM = 5'd10;
            dest_reg_WB = 5'd5;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Double Hazard (Both MEM and WB match - MEM priority)");
            test_num = test_num + 1;
            src_reg_EX = 5'd8;
            dest_reg_MEM = 5'd8;
            dest_reg_WB = 5'd8;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Register 0 Hazard (Should not forward)");
            test_num = test_num + 1;
            src_reg_EX = 5'd0;
            dest_reg_MEM = 5'd0;
            dest_reg_WB = 5'd0;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Match but RegWrite is disabled (MEM)");
            test_num = test_num + 1;
            src_reg_EX = 5'd15;
            dest_reg_MEM = 5'd15;
            dest_reg_WB = 5'd20;
            reg_write_MEM = 1'b0;
            reg_write_WB = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Match but RegWrite is disabled (WB)");
            test_num = test_num + 1;
            src_reg_EX = 5'd15;
            dest_reg_MEM = 5'd20;
            dest_reg_WB = 5'd15;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: WB hazard when MEM instruction writes to different register");
            test_num = test_num + 1;
            src_reg_EX = 5'd4;
            dest_reg_MEM = 5'd12;
            dest_reg_WB = 5'd4;
            reg_write_MEM = 1'b1;
            reg_write_WB = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding Testbench");
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
