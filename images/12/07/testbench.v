`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] X;
    reg select;
    wire [4:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .A(A),
        .B(B),
        .X(X),
        .select(select),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (select=0)", test_num);
            A = 5'd10;
            B = 5'd5;
            X = 5'd20;
            select = 1'b0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select External Value X (select=1)", test_num);
            A = 5'd10;
            B = 5'd5;
            X = 5'd20;
            select = 1'b1;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5-bit Addition Overflow (select=0)", test_num);
            A = 5'd31;
            B = 5'd1;
            X = 5'd10;
            select = 1'b0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5-bit Addition Wrap-around (select=0)", test_num);
            A = 5'd20;
            B = 5'd15;
            X = 5'd5;
            select = 1'b0;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select External Value with Sum Overflow (select=1)", test_num);
            A = 5'd31;
            B = 5'd31;
            X = 5'd12;
            select = 1'b1;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs (select=0)", test_num);
            A = 5'd0;
            B = 5'd0;
            X = 5'd31;
            select = 1'b0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Value for X (select=1)", test_num);
            A = 5'd0;
            B = 5'd0;
            X = 5'h1F;
            select = 1'b1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Resulting Sum is 31 (select=0)", test_num);
            A = 5'd15;
            B = 5'd16;
            X = 5'd0;
            select = 1'b0;
            #1;

            check_outputs(5'd31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding Testbench");
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
        input [4:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
