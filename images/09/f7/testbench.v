`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg [1:0] Op;
    reg [1:0] last_A;
    reg [1:0] last_B;
    wire hazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .A(A),
        .B(B),
        .Op(Op),
        .last_A(last_A),
        .last_B(last_B),
        .hazard(hazard)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazard - All operands different", test_num);
            A = 2'b00;
            B = 2'b01;
            Op = 2'b00;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard - A matches last_A", test_num);
            A = 2'b10;
            B = 2'b01;
            Op = 2'b01;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard - B matches last_B", test_num);
            A = 2'b00;
            B = 2'b11;
            Op = 2'b10;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard - A matches last_B", test_num);
            A = 2'b11;
            B = 2'b00;
            Op = 2'b00;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard - B matches last_A", test_num);
            A = 2'b01;
            B = 2'b10;
            Op = 2'b01;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple hazards - Both A and B match previous operands", test_num);
            A = 2'b10;
            B = 2'b11;
            Op = 2'b10;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple hazards - Crossed operands", test_num);
            A = 2'b11;
            B = 2'b10;
            Op = 2'b00;
            last_A = 2'b10;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard with all operands zero", test_num);
            A = 2'b00;
            B = 2'b00;
            Op = 2'b01;
            last_A = 2'b00;
            last_B = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazard - Op change but no operand overlap", test_num);
            A = 2'b11;
            B = 2'b11;
            Op = 2'b10;
            last_A = 2'b00;
            last_B = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard - Sequential identical reads", test_num);
            A = 2'b01;
            B = 2'b01;
            Op = 2'b00;
            last_A = 2'b01;
            last_B = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection Testbench");
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
        input expected_hazard;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard === (expected_hazard ^ hazard ^ expected_hazard)) begin
                $display("PASS");
                $display("  Outputs: hazard=%b",
                         hazard);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard=%b",
                         expected_hazard);
                $display("  Got:      hazard=%b",
                         hazard);
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
