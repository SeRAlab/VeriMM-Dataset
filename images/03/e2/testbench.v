`timescale 1ns/1ps

module paeth_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] L;
    reg [7:0] U;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    paeth_filter dut (
        .A(A),
        .L(L),
        .U(U),
        .P(P)
    );
    task testcase001;

        begin
            $display("Test Case 001: All pixels zero");
            L = 8'd0; A = 8'd0; U = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All pixels identical");
            L = 8'd128; A = 8'd128; U = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Left is closest");
            L = 8'd100; A = 8'd50; U = 8'd50;




            #1;





            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Above is closest");
            L = 8'd50; A = 8'd100; U = 8'd50;




            #1;





            check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Upper-Left is closest");
            L = 8'd100; A = 8'd120; U = 8'd110;




            #1;





            check_outputs(8'd110);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Tie-break L vs A (L wins)");
            L = 8'd100; A = 8'd100; U = 8'd80;





            #1;






            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Tie-break A vs U (A wins)");
            L = 8'd50; A = 8'd100; U = 8'd80;






            L = 8'd150; A = 8'd100; U = 8'd125;





            L = 8'd10; A = 8'd100; U = 55;






            L = 8'd120; A = 8'd80; U = 100;





            L = 8'd0; A = 8'd100; U = 50;





            L = 8'd100; A = 8'd20; U = 40;








            L = 8'd40; A = 8'd10; U = 8'd30;


            #1;



            check_outputs(8'd10);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Maximum values");
            L = 8'd255; A = 8'd255; U = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Negative intermediate p");
            L = 8'd10; A = 8'd10; U = 8'd100;





            #1;






            check_outputs(8'd10);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Large intermediate p");
            L = 8'd250; A = 8'd250; U = 8'd10;





            #1;






            check_outputs(8'd250);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("paeth_filter Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
