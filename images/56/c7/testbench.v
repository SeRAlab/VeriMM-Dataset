`timescale 1ns/1ps

module state_ctrl_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg [3:0] v;
    wire V2;
    wire V3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_ctrl dut (
        .r(r),
        .v(v),
        .V2(V2),
        .V3(V3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State P (v=0001), r=0 -> Expected Q (V2=1, V3=0)", test_num);
            r = 0;
            v = 4'b0001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State P (v=0001), r=1 -> Expected R (V2=0, V3=1)", test_num);
            r = 1;
            v = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State Q (v=0010), r=0 -> Expected P (V2=0, V3=0)", test_num);
            r = 0;
            v = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State Q (v=0010), r=1 -> Expected S (V2=0, V3=0)", test_num);
            r = 1;
            v = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State R (v=0100), r=0 -> Expected S (V2=0, V3=0)", test_num);
            r = 0;
            v = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State R (v=0100), r=1 -> Expected P (V2=0, V3=0)", test_num);
            r = 1;
            v = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State S (v=1000), r=0 -> Expected Q (V2=1, V3=0)", test_num);
            r = 0;
            v = 4'b1000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State S (v=1000), r=1 -> Expected R (V2=0, V3=1)", test_num);
            r = 1;
            v = 4'b1000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros input -> Expected (V2=0, V3=0)", test_num);
            r = 0;
            v = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones input, r=0 -> Expected (V2=1, V3=0) based on logic (v1+v4)&~r", test_num);
            r = 0;
            v = 4'b1111;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_ctrl Testbench");
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
        input expected_V2;
        input expected_V3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V2 === (expected_V2 ^ V2 ^ expected_V2) &&
                expected_V3 === (expected_V3 ^ V3 ^ expected_V3)) begin
                $display("PASS");
                $display("  Outputs: V2=%b, V3=%b",
                         V2, V3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V2=%b, V3=%b",
                         expected_V2, expected_V3);
                $display("  Got:      V2=%b, V3=%b",
                         V2, V3);
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
