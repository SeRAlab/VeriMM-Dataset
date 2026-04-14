`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg [1:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select I0 when I0=0 (Others are 1)", test_num);
            S = 2'b00;
            I0 = 1'b0; I1 = 1'b1; I2 = 1'b1; I3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select I0 when I0=1 (Others are 0)", test_num);
            S = 2'b00;
            I0 = 1'b1; I1 = 1'b0; I2 = 1'b0; I3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select I1 when I1=0 (Others are 1)", test_num);
            S = 2'b01;
            I0 = 1'b1; I1 = 1'b0; I2 = 1'b1; I3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select I1 when I1=1 (Others are 0)", test_num);
            S = 2'b01;
            I0 = 1'b0; I1 = 1'b1; I2 = 1'b0; I3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select I2 when I2=0 (Others are 1)", test_num);
            S = 2'b10;
            I0 = 1'b1; I1 = 1'b1; I2 = 1'b0; I3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select I2 when I2=1 (Others are 0)", test_num);
            S = 2'b10;
            I0 = 1'b0; I1 = 1'b0; I2 = 1'b1; I3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select I3 when I3=0 (Others are 1)", test_num);
            S = 2'b11;
            I0 = 1'b1; I1 = 1'b1; I2 = 1'b1; I3 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select I3 when I3=1 (Others are 0)", test_num);
            S = 2'b11;
            I0 = 1'b0; I1 = 1'b0; I2 = 1'b0; I3 = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: All inputs high, switching select", test_num);
            I0 = 1'b1; I1 = 1'b1; I2 = 1'b1; I3 = 1'b1;
            S = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: All inputs low, switching select", test_num);
            I0 = 1'b0; I1 = 1'b0; I2 = 1'b0; I3 = 1'b0;
            S = 2'b01;
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
        $display("mux4to1 Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
