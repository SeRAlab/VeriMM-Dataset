`timescale 1ns/1ps

module logic_gate_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg [1:0] B1;
    reg [1:0] B2;
    reg C1;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_gate dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A1 = 1'b1; A2 = 1'b0; B1 = 2'b00; B2 = 2'b11; C1 = 1'b0;
            $display("Test %0d: Priority A1=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A1 = 1'b1; A2 = 1'b1; B1 = 2'b01; B2 = 2'b01; C1 = 1'b1;
            $display("Test %0d: Priority A1=1 (with A2 and C1 set)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A1 = 1'b0; A2 = 1'b1; B1 = 2'b11; B2 = 2'b00; C1 = 1'b1;
            $display("Test %0d: Priority A1=0, A2=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A1 = 1'b0; A2 = 1'b1; B1 = 2'b00; B2 = 2'b00; C1 = 1'b0;
            $display("Test %0d: Priority A1=0, A2=1 (with B1=B2)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b10; B2 = 2'b01; C1 = 1'b0;
            $display("Test %0d: A1=0, A2=0, B1 > B2 (2 > 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b11; B2 = 2'b00; C1 = 1'b0;
            $display("Test %0d: A1=0, A2=0, B1 > B2 (3 > 0)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b01; B2 = 2'b10; C1 = 1'b1;
            $display("Test %0d: A1=0, A2=0, B1 < B2 (1 < 2)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b00; B2 = 2'b01; C1 = 1'b1;
            $display("Test %0d: A1=0, A2=0, B1 < B2 (0 < 1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b00; B2 = 2'b00; C1 = 1'b1;
            $display("Test %0d: A1=0, A2=0, B1 == B2 (0=0), C1=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b11; B2 = 2'b11; C1 = 1'b1;
            $display("Test %0d: A1=0, A2=0, B1 == B2 (3=3), C1=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b10; B2 = 2'b10; C1 = 1'b0;
            $display("Test %0d: A1=0, A2=0, B1 == B2 (2=2), C1=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            A1 = 1'b0; A2 = 1'b0; B1 = 2'b00; B2 = 2'b00; C1 = 1'b0;
            $display("Test %0d: A1=0, A2=0, B1 == B2 (0=0), C1=0", test_num);
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
        $display("logic_gate Testbench");
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
        testcase011();
        testcase012();
        
        
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
