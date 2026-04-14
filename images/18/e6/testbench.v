`timescale 1ns/1ps

module adder_5bit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg EN;
    wire [5:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_5bit dut (
        .A(A),
        .B(B),
        .EN(EN),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=0, A=15, B=15", test_num);
            EN = 0;
            A = 5'd15;
            B = 5'd15;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=1, A=0, B=0", test_num);
            EN = 1;
            A = 5'd0;
            B = 5'd0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=1, A=31, B=0", test_num);
            EN = 1;
            A = 5'd31;
            B = 5'd0;
            #1;

            check_outputs(6'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=1, A=0, B=31", test_num);
            EN = 1;
            A = 5'd0;
            B = 5'd31;
            #1;

            check_outputs(6'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=1, A=31, B=31 (Max Sum)", test_num);
            EN = 1;
            A = 5'd31;
            B = 5'd31;
            #1;

            check_outputs(6'd62);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=1, A=10, B=20", test_num);
            EN = 1;
            A = 5'd10;
            B = 5'd20;
            #1;

            check_outputs(6'd30);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN=1, A=15, B=1", test_num);
            EN = 1;
            A = 5'd15;
            B = 5'd1;
            #1;

            check_outputs(6'd16);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: EN transitioning 1 -> 0", test_num);
            EN = 1;
            A = 5'd5;
            B = 5'd5;
            #5;
            EN = 0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_5bit Testbench");
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
        input [5:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
