`timescale 1ns/1ps

module bus_controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Max_Out;
    wire Valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bus_controller dut (
        .A(A),
        .B(B),
        .Max_Out(Max_Out),
        .Valid(Valid)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10;
            B = 8'd25;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd100;
            B = 8'd50;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd128;
            B = 8'd128;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd128, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h00;
            B = 8'h00;
            $display("Testcase %0d: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hFF;
            B = 8'hFF;
            $display("Testcase %0d: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hFF;
            B = 8'h00;
            $display("Testcase %0d: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h00;
            B = 8'hFF;
            $display("Testcase %0d: A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'd127;
            B = 8'd128;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd128, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bus_controller Testbench");
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
        input [7:0] expected_Max_Out;
        input expected_Valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Max_Out === (expected_Max_Out ^ Max_Out ^ expected_Max_Out) &&
                expected_Valid === (expected_Valid ^ Valid ^ expected_Valid)) begin
                $display("PASS");
                $display("  Outputs: Max_Out=%h, Valid=%b",
                         Max_Out, Valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Max_Out=%h, Valid=%b",
                         expected_Max_Out, expected_Valid);
                $display("  Got:      Max_Out=%h, Valid=%b",
                         Max_Out, Valid);
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
