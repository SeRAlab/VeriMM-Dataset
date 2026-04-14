`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D0;
    reg [3:0] D1;
    reg [3:0] D2;
    reg [3:0] D3;
    reg [1:0] S0;
    reg [1:0] S1;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .S0(S0),
        .S1(S1),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 (S1=Low, S0=Low)", test_num);
            D0 = 4'hA; D1 = 4'h5; D2 = 4'hF; D3 = 4'h0;
            S1 = 2'b00; S0 = 2'b00;
            #10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 (S1=Low, S0=High)", test_num);
            D0 = 4'hA; D1 = 4'h5; D2 = 4'hF; D3 = 4'h0;
            S1 = 2'b00; S0 = 2'b01;
            #10;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D2 (S1=High, S0=Low)", test_num);
            D0 = 4'hA; D1 = 4'h5; D2 = 4'hF; D3 = 4'h0;
            S1 = 2'b01; S0 = 2'b00;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D3 (S1=High, S0=High)", test_num);
            D0 = 4'hA; D1 = 4'h5; D2 = 4'hF; D3 = 4'h0;
            S1 = 2'b01; S0 = 2'b01;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Select (S0 out of range)", test_num);
            D0 = 4'h1; D1 = 4'h2; D2 = 4'h3; D3 = 4'h4;
            S1 = 2'b00; S0 = 2'b10;
            #10;
            #1;

            check_outputs(4'bX);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify all-ones data lines", test_num);
            D0 = 4'hF; D1 = 4'hF; D2 = 4'hF; D3 = 4'hF;
            S1 = 2'b01; S0 = 2'b00;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify all-zeros data lines", test_num);
            D0 = 4'h0; D1 = 4'h0; D2 = 4'h0; D3 = 4'h0;
            S1 = 2'b01; S0 = 2'b01;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 with different data", test_num);
            D0 = 4'h3; D1 = 4'hC; D2 = 4'h9; D3 = 4'h6;
            S1 = 2'b00; S0 = 2'b01;
            #10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
