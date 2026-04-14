`timescale 1ns/1ps

module mac_address_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] mac1;
    reg [4:0] mac2;
    wire equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_comparator dut (
        .mac1(mac1),
        .mac2(mac2),
        .equal(equal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros (Equal)", test_num);
        mac1 = 5'b00000;
        mac2 = 5'b00000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones (Equal)", test_num);
        mac1 = 5'b11111;
        mac2 = 5'b11111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Identical mid-range values (Equal)", test_num);
        mac1 = 5'b10101;
        mac2 = 5'b10101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Differ by LSB (Not Equal)", test_num);
        mac1 = 5'b00000;
        mac2 = 5'b00001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Differ by MSB (Not Equal)", test_num);
        mac1 = 5'b00000;
        mac2 = 5'b10000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Differ by middle bit (Not Equal)", test_num);
        mac1 = 5'b11111;
        mac2 = 5'b11011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise inverses (Not Equal)", test_num);
        mac1 = 5'b10101;
        mac2 = 5'b01010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Swapped values (Not Equal)", test_num);
        mac1 = 5'b00111;
        mac2 = 5'b11100;
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
        $display("mac_address_comparator Testbench");
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
        input expected_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal)) begin
                $display("PASS");
                $display("  Outputs: equal=%b",
                         equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b",
                         expected_equal);
                $display("  Got:      equal=%b",
                         equal);
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
