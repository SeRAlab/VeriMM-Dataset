`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_ex;
    reg [4:0] dest_mem;
    reg [4:0] src1;
    reg [4:0] src2;
    wire forward_ex;
    wire forward_mem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .dest_ex(dest_ex),
        .dest_mem(dest_mem),
        .src1(src1),
        .src2(src2),
        .forward_ex(forward_ex),
        .forward_mem(forward_mem)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: No Hazard (Distinct Registers)", test_num);
        src1 = 5'd1; src2 = 5'd2; dest_ex = 5'd3; dest_mem = 5'd4;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: EX Hazard on src1", test_num);
        src1 = 5'd10; src2 = 5'd11; dest_ex = 5'd10; dest_mem = 5'd12;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: EX Hazard on src2", test_num);
        src1 = 5'd5; src2 = 5'd6; dest_ex = 5'd6; dest_mem = 5'd7;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: MEM Hazard on src1", test_num);
        src1 = 5'd15; src2 = 5'd16; dest_ex = 5'd17; dest_mem = 5'd15;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: MEM Hazard on src2", test_num);
        src1 = 5'd20; src2 = 5'd21; dest_ex = 5'd22; dest_mem = 5'd21;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: EX Hazard (src1) and MEM Hazard (src2)", test_num);
        src1 = 5'd1; src2 = 5'd2; dest_ex = 5'd1; dest_mem = 5'd2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: MEM Hazard (src1) and EX Hazard (src2)", test_num);
        src1 = 5'd1; src2 = 5'd2; dest_ex = 5'd2; dest_mem = 5'd1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Register Zero Check (EX stage)", test_num);
        src1 = 5'd0; src2 = 5'd1; dest_ex = 5'd0; dest_mem = 5'd5;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Register Zero Check (MEM stage)", test_num);
        src1 = 5'd2; src2 = 5'd0; dest_ex = 5'd5; dest_mem = 5'd0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Overlapping Hazard (src1 in both EX and MEM)", test_num);
        src1 = 5'd8; src2 = 5'd9; dest_ex = 5'd8; dest_mem = 5'd8;

        #1;


        check_outputs(1'b1, 1'b1);
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
        input expected_forward_ex;
        input expected_forward_mem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_ex === (expected_forward_ex ^ forward_ex ^ expected_forward_ex) &&
                expected_forward_mem === (expected_forward_mem ^ forward_mem ^ expected_forward_mem)) begin
                $display("PASS");
                $display("  Outputs: forward_ex=%b, forward_mem=%b",
                         forward_ex, forward_mem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_ex=%b, forward_mem=%b",
                         expected_forward_ex, expected_forward_mem);
                $display("  Got:      forward_ex=%b, forward_mem=%b",
                         forward_ex, forward_mem);
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
