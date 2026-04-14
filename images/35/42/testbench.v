`timescale 1ns/1ps

module qam_mapper_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [1:0] I;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_mapper dut (
        .symbol(symbol),
        .I(I),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0000", test_num);
            symbol = 4'b0000;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0001", test_num);
            symbol = 4'b0001;
            #1;

            check_outputs(2'd1, 2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0010", test_num);
            symbol = 4'b0010;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0011", test_num);
            symbol = 4'b0011;
            #1;

            check_outputs(2'd3, 2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0100", test_num);
            symbol = 4'b0100;
            #1;

            check_outputs(2'd3, 2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0101", test_num);
            symbol = 4'b0101;
            #1;

            check_outputs(2'd3, 2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0110", test_num);
            symbol = 4'b0110;
            #1;

            check_outputs(2'd1, 2'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 0111", test_num);
            symbol = 4'b0111;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1000", test_num);
            symbol = 4'b1000;
            #1;

            check_outputs(2'd1, 2'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1001", test_num);
            symbol = 4'b1001;
            #1;

            check_outputs(2'd3, 2'd3);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1010", test_num);
            symbol = 4'b1010;
            #1;

            check_outputs(2'd3, 2'd1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1011", test_num);
            symbol = 4'b1011;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1100", test_num);
            symbol = 4'b1100;
            #1;

            check_outputs(2'd3, 2'd1);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1101", test_num);
            symbol = 4'b1101;
            #1;

            check_outputs(2'd1, 2'd3);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1110", test_num);
            symbol = 4'b1110;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input symbol = 1111", test_num);
            symbol = 4'b1111;
            #1;

            check_outputs(2'd3, 2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_mapper Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [1:0] expected_I;
        input [1:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I === (expected_I ^ I ^ expected_I) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: I=%h, Q=%h",
                         I, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h, Q=%h",
                         expected_I, expected_Q);
                $display("  Got:      I=%h, Q=%h",
                         I, Q);
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
