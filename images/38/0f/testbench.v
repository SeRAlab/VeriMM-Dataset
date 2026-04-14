`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dest;
    reg [3:0] src1;
    reg [3:0] src2;
    reg valid;
    wire forwardA;
    wire forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest(dest),
        .src1(src1),
        .src2(src2),
        .valid(valid),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Valid low, registers match", test_num);
        dest = 4'h5;
        src1 = 4'h5;
        src2 = 4'h5;
        valid = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward A (src1 match)", test_num);
        dest = 4'h3;
        src1 = 4'h3;
        src2 = 4'h7;
        valid = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward B (src2 match)", test_num);
        dest = 4'hA;
        src1 = 4'h2;
        src2 = 4'hA;
        valid = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward both (src1 and src2 match)", test_num);
        dest = 4'hF;
        src1 = 4'hF;
        src2 = 4'hF;
        valid = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No match, valid high", test_num);
        dest = 4'h1;
        src1 = 4'h2;
        src2 = 4'h3;
        valid = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Register 0 matching", test_num);
        dest = 4'h0;
        src1 = 4'h0;
        src2 = 4'h1;
        valid = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Toggling valid signal with match", test_num);
        dest = 4'hC;
        src1 = 4'hC;
        src2 = 4'hC;
        valid = 0;
        #5;
        valid = 1;
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
        $display("data_forwarding_unit Testbench");
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
