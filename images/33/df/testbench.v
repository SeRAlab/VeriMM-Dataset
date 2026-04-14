`timescale 1ns/1ps

module decoder4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder4to16 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Input A = 4'b0000 (0)", test_num);
            A = 4'b0000;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input A = 4'b0001 (1)", test_num);
            A = 4'b0001;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input A = 4'b0010 (2)", test_num);
            A = 4'b0010;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input A = 4'b0011 (3)", test_num);
            A = 4'b0011;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Input A = 4'b0100 (4)", test_num);
            A = 4'b0100;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Input A = 4'b0111 (7)", test_num);
            A = 4'b0111;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Input A = 4'b1000 (8)", test_num);
            A = 4'b1000;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Input A = 4'b1010 (10)", test_num);
            A = 4'b1010;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Input A = 4'b1101 (13)", test_num);
            A = 4'b1101;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Input A = 4'b1111 (15)", test_num);
            A = 4'b1111;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder4to16 Testbench");
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
