`timescale 1ns/1ps

module magnitude_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire E;
    wire G;
    wire L;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    magnitude_comparator dut (
        .A(A),
        .B(B),
        .E(E),
        .G(G),
        .L(L)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=0, B=0 (Equal - Zero)", test_num);
        A = 4'd0; B = 4'd0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=15, B=15 (Equal - Max)", test_num);
        A = 4'd15; B = 4'd15;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=7, B=7 (Equal - Mid)", test_num);
        A = 4'd7; B = 4'd7;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=15, B=0 (Greater - Extremes)", test_num);
        A = 4'd15; B = 4'd0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=0, B=15 (Less - Extremes)", test_num);
        A = 4'd0; B = 4'd15;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=8, B=7 (Greater - MSB vs lower bits)", test_num);
        A = 4'd8; B = 4'd7;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=7, B=8 (Less - MSB vs lower bits)", test_num);
        A = 4'd7; B = 4'd8;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=10, B=5 (Greater - Alternate bits)", test_num);
        A = 4'd10; B = 4'd5;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=3, B=12 (Less - Middle bits)", test_num);
        A = 4'd3; B = 4'd12;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: A=14, B=15 (Less - One LSB difference)", test_num);
        A = 4'd14; B = 4'd15;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("magnitude_comparator Testbench");
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
        input expected_E;
        input expected_G;
        input expected_L;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_L === (expected_L ^ L ^ expected_L)) begin
                $display("PASS");
                $display("  Outputs: E=%b, G=%b, L=%b",
                         E, G, L);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, G=%b, L=%b",
                         expected_E, expected_G, expected_L);
                $display("  Got:      E=%b, G=%b, L=%b",
                         E, G, L);
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
