`timescale 1ns/1ps

module vector_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire OVF;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_adder dut (
        .A(A),
        .B(B),
        .OVF(OVF),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Simple addition without overflow (2 + 3)", test_num);
            A = 4'd2;
            B = 4'd3;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Boundary condition - Max sum without overflow (10 + 5)", test_num);
            A = 4'd10;
            B = 4'd5;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Minimum overflow (8 + 8 = 16)", test_num);
            A = 4'd8;
            B = 4'd8;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum input values (15 + 15 = 30)", test_num);
            A = 4'hF;
            B = 4'hF;
            #1;

            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Overflow with remainder (9 + 9 = 18)", test_num);
            A = 4'd9;
            B = 4'd9;
            #1;

            check_outputs(1'b1, 4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Single bit addition (1 + 1)", test_num);
            A = 4'd1;
            B = 4'd1;
            #1;

            check_outputs(1'b0, 4'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Max value plus zero (15 + 0)", test_num);
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_adder Testbench");
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
        input expected_OVF;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVF === (expected_OVF ^ OVF ^ expected_OVF) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: OVF=%b, SUM=%h",
                         OVF, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVF=%b, SUM=%h",
                         expected_OVF, expected_SUM);
                $display("  Got:      OVF=%b, SUM=%h",
                         OVF, SUM);
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
