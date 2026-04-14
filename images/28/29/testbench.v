`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg S;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .A(A),
        .B(B),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 5'b01010;
            B = 5'b10101;
            S = 1'b0;
            $display("Test %0d: Select A (S=0) with basic values", test_num);
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 5'b01010;
            B = 5'b10101;
            S = 1'b1;
            $display("Test %0d: Select B (S=1) with basic values", test_num);
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 5'b00000;
            B = 5'b11111;
            S = 1'b0;
            $display("Test %0d: Select A (S=0) with all zeros", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 5'b00000;
            B = 5'b11111;
            S = 1'b1;
            $display("Test %0d: Select B (S=1) with all ones", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 5'h1F;
            B = 5'h00;
            S = 1'b0;
            $display("Test %0d: Select A (S=0) with hex 1F", test_num);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 5'h1F;
            B = 5'h00;
            S = 1'b1;
            $display("Test %0d: Select B (S=1) with hex 00", test_num);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 5'b11001;
            B = 5'b00110;
            S = 1'b0;
            $display("Test %0d: Random pattern select A", test_num);
            #1;

            check_outputs(5'b11001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 5'b11001;
            B = 5'b00110;
            S = 1'b1;
            $display("Test %0d: Random pattern select B", test_num);
            #1;

            check_outputs(5'b00110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1 Testbench");
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
        input [4:0] expected_Y;
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
