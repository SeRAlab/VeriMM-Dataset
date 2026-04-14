`timescale 1ns/1ps

module decoder_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg EN;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder dut (
        .A(A),
        .B(B),
        .EN(EN),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: EN=0 (Disabled) - All outputs should be high", test_num);
            EN = 0; A = 0; B = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: EN=1, B=0, A=0 - Y0 should be low", test_num);
            EN = 1; B = 0; A = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: EN=1, B=0, A=1 - Y1 should be low", test_num);
            EN = 1; B = 0; A = 1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: EN=1, B=1, A=0 - Y2 should be low", test_num);
            EN = 1; B = 1; A = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: EN=1, B=1, A=1 - Y3 should be low", test_num);
            EN = 1; B = 1; A = 1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: EN=0, B=1, A=1 - All outputs should be high", test_num);
            EN = 0; B = 1; A = 1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
