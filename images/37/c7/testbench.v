`timescale 1ns/1ps

module two_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire [2:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    two_bit_adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0", test_num);
            A = 2'b00;
            B = 2'b00;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 1", test_num);
            A = 2'b00;
            B = 2'b01;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1 + 1", test_num);
            A = 2'b01;
            B = 2'b01;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2 + 1", test_num);
            A = 2'b10;
            B = 2'b01;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2 + 2 (Carry Out)", test_num);
            A = 2'b10;
            B = 2'b10;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 3 + 1 (Carry Out)", test_num);
            A = 2'b11;
            B = 2'b01;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 3 + 2 (Carry Out)", test_num);
            A = 2'b11;
            B = 2'b10;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 3 + 3 (Max Sum)", test_num);
            A = 2'b11;
            B = 2'b11;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1 + 2", test_num);
            A = 2'b01;
            B = 2'b10;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 3", test_num);
            A = 2'b00;
            B = 2'b11;
            #1;

            check_outputs(3'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("two_bit_adder Testbench");
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
        input [2:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
