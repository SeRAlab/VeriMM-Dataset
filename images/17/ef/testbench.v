`timescale 1ns/1ps

module mux_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D0;
    reg [15:0] D1;
    reg [15:0] D2;
    reg [15:0] D3;
    reg [1:0] S;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16bit dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D0", test_num);
            D0 = 16'hAAAA;
            D1 = 16'h5555;
            D2 = 16'hCCCC;
            D3 = 16'h3333;
            S  = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D1", test_num);
            D0 = 16'hAAAA;
            D1 = 16'h5555;
            D2 = 16'hCCCC;
            D3 = 16'h3333;
            S  = 2'b01;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D2", test_num);
            D0 = 16'hAAAA;
            D1 = 16'h5555;
            D2 = 16'hCCCC;
            D3 = 16'h3333;
            S  = 2'b10;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D3", test_num);
            D0 = 16'hAAAA;
            D1 = 16'h5555;
            D2 = 16'hCCCC;
            D3 = 16'h3333;
            S  = 2'b11;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs High, Select D0", test_num);
            D0 = 16'hFFFF;
            D1 = 16'hFFFF;
            D2 = 16'hFFFF;
            D3 = 16'hFFFF;
            S  = 2'b00;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs, Select D2", test_num);
            D0 = 16'h0000;
            D1 = 16'h0000;
            D2 = 16'h0000;
            D3 = 16'h0000;
            S  = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Isolation (Change non-selected D)", test_num);
            D0 = 16'h1234;
            D1 = 16'h5678;
            D2 = 16'h9ABC;
            D3 = 16'hDEF0;
            S  = 2'b01;
            #5;
            D0 = 16'hFFFF;
            D2 = 16'h0000;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            D0 = 16'hF0F0;
            D1 = 16'h0F0F;
            D2 = 16'hAAAA;
            D3 = 16'h5555;
            S  = 2'b11;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_16bit Testbench");
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
        input [15:0] expected_Y;
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
