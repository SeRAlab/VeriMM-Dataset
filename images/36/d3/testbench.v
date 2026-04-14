`timescale 1ns/1ps

module kogge_stone_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [8:0] COUT;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kogge_stone_adder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h00; B = 8'h00;

            #1;


            check_outputs(9'h000, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hFF; B = 8'h00;

            #1;


            check_outputs(9'h0FF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hFF; B = 8'h01;

            #1;


            check_outputs(9'h100, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'hFF; B = 8'hFF;

            #1;


            check_outputs(9'h1FE, 8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'h55; B = 8'hAA;

            #1;


            check_outputs(9'h0FF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h01; B = 8'h01;

            #1;


            check_outputs(9'h002, 8'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h80; B = 8'h80;

            #1;


            check_outputs(9'h100, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'h7F; B = 8'h01;

            #1;


            check_outputs(9'h080, 8'h80);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'h12; B = 8'h34;

            #1;


            check_outputs(9'h046, 8'h46);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'hA5; B = 8'h5A;

            #1;


            check_outputs(9'h0FF, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kogge_stone_adder Testbench");
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
        input [8:0] expected_COUT;
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%h, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%h, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%h, SUM=%h",
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
