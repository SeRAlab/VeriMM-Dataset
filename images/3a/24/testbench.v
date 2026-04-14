`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [1:0] forward;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .dest(dest),
        .src1(src1),
        .src2(src2),
        .forward(forward)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: No forwarding match", test_num);
        src1 = 5'd1;
        src2 = 5'd2;
        dest = 5'd3;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Forward from src1 (src1 == dest)", test_num);
        src1 = 5'd10;
        src2 = 5'd15;
        dest = 5'd10;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Forward from src2 (src2 == dest)", test_num);
        src1 = 5'd8;
        src2 = 5'd20;
        dest = 5'd20;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Conflict case - Both src1 and src2 match dest (Priority to src1)", test_num);
        src1 = 5'd7;
        src2 = 5'd7;
        dest = 5'd7;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Zero register case (Register 0 matching)", test_num);
        src1 = 5'd0;
        src2 = 5'd0;
        dest = 5'd0;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Max register value (31)", test_num);
        src1 = 5'd31;
        src2 = 5'd1;
        dest = 5'd31;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: src2 match with high bit registers", test_num);
        src1 = 5'd5;
        src2 = 5'd31;
        dest = 5'd31;
        #1;

        check_outputs(2'd2);
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
        input [1:0] expected_forward;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward === (expected_forward ^ forward ^ expected_forward)) begin
                $display("PASS");
                $display("  Outputs: forward=%h",
                         forward);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward=%h",
                         expected_forward);
                $display("  Got:      forward=%h",
                         forward);
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
