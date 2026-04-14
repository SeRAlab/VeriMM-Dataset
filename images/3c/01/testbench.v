`timescale 1ns/1ps

module brent_kung_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire COUT;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    brent_kung_adder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (No Carry)", test_num);
            A = 8'h12;
            B = 8'h34;

            #1;


            check_outputs(1'b0, 8'h46);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Carry Out", test_num);
            A = 8'hFF;
            B = 8'h01;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones Sum", test_num);
            A = 8'hAA;
            B = 8'h55;

            #1;


            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal Carry Propagation", test_num);
            A = 8'h0F;
            B = 8'h01;

            #1;


            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Values with Carry", test_num);
            A = 8'hF0;
            B = 8'hF0;

            #1;


            check_outputs(1'b1, 8'hE0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Carry", test_num);
            A = 8'h55;
            B = 8'h55;

            #1;


            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Input Addition", test_num);
            A = 8'hFF;
            B = 8'hFF;

            #1;


            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Addition", test_num);
            A = 8'h01;
            B = 8'h01;
            #1;

            check_outputs(1'b0, 8'h02);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern", test_num);
            A = 8'hC3;
            B = 8'h3C;

            #1;


            check_outputs(1'b0, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("brent_kung_adder Testbench");
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
        input expected_COUT;
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
