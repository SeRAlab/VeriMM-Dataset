`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg mem_read;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rt;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .mem_read(mem_read),
        .rs1(rs1),
        .rs2(rs2),
        .rt(rt),
        .stall(stall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Load (mem_read=0), Registers match - Should NOT stall", test_num);
            mem_read = 1'b0;
            rs1 = 5'd10;
            rs2 = 5'd11;
            rt  = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load-Use Hazard on rs1 - Should stall", test_num);
            mem_read = 1'b1;
            rs1 = 5'd15;
            rs2 = 5'd20;
            rt  = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Load-Use Hazard on rs2 - Should stall", test_num);
            mem_read = 1'b1;
            rs1 = 5'd5;
            rs2 = 5'd8;
            rt  = 5'd8;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Load occurring but no register match - Should NOT stall", test_num);
            mem_read = 1'b1;
            rs1 = 5'd1;
            rs2 = 5'd2;
            rt  = 5'd3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Load-Use Hazard both rs1 and rs2 match rt - Should stall", test_num);
            mem_read = 1'b1;
            rs1 = 5'd25;
            rs2 = 5'd25;
            rt  = 5'd25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Registers are zero, Load matching R0 - Check logic consistency", test_num);
            mem_read = 1'b1;
            rs1 = 5'd0;
            rs2 = 5'd0;
            rt  = 5'd0;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Resetting signals to idle state - Should NOT stall", test_num);
            mem_read = 1'b0;
            rs1 = 5'd0;
            rs2 = 5'd0;
            rt  = 5'd31;
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
        input expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: stall=%b",
                         stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%b",
                         expected_stall);
                $display("  Got:      stall=%b",
                         stall);
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
