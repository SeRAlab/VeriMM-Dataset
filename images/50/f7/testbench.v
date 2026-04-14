`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] A;
    reg [9:0] B;
    wire A_gt_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=0, B=0 (Equality)", test_num);
        A = 10'd0;
        B = 10'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=1, B=0 (A > B)", test_num);
        A = 10'd1;
        B = 10'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=0, B=1 (A < B)", test_num);
        A = 10'd0;
        B = 10'd1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=1023, B=1023 (Equality at Max)", test_num);
        A = 10'd1023;
        B = 10'd1023;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=1023, B=1022 (A > B at Max)", test_num);
        A = 10'd1023;
        B = 10'd1022;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=1022, B=1023 (A < B at Max)", test_num);
        A = 10'd1022;
        B = 10'd1023;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=512, B=511 (A > B Middle Range)", test_num);
        A = 10'd512;
        B = 10'd511;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=512 (MSB set), B=511 (Lower bits set)", test_num);
        A = 10'b10_0000_0000;
        B = 10'b01_1111_1111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=1023, B=0 (Max difference)", test_num);
        A = 10'd1023;
        B = 10'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=0, B=1023 (Min difference)", test_num);
        A = 10'd0;
        B = 10'd1023;
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
        $display("comparator Testbench");
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
        input expected_A_gt_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_gt_B === (expected_A_gt_B ^ A_gt_B ^ expected_A_gt_B)) begin
                $display("PASS");
                $display("  Outputs: A_gt_B=%b",
                         A_gt_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_gt_B=%b",
                         expected_A_gt_B);
                $display("  Got:      A_gt_B=%b",
                         A_gt_B);
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
