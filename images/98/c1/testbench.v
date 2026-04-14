`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [26:0] A;
    reg [26:0] B;
    wire [53:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero multiplication", test_num);
            A = 27'h0;
            B = 27'h0;
            #1;

            check_outputs(54'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiply by one", test_num);
            A = 27'h7FFFFFF;
            B = 27'h1;
            #1;

            check_outputs(54'h7FFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small numbers multiplication", test_num);
            A = 27'd12345;
            B = 27'd6789;

            #1;


            check_outputs(54'h4FF2AD5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of two multiplication", test_num);
            A = 27'h4000;
            B = 27'h2000;

            #1;


            check_outputs(54'h8000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum unsigned values", test_num);
            A = 27'h7FFFFFF;
            B = 27'h7FFFFFF;


            #1;



            check_outputs(54'h3FFFFFE0000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns", test_num);
            A = 27'h5555555;
            B = 27'h2AAAAAA;


            #1;



            check_outputs(54'hE38E38B1C71C2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large arbitrary values", test_num);
            A = 27'h6A5C392;
            B = 27'h1B2F4E5;


            #1;



            check_outputs(54'hB4B398328AD52);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range overflow check", test_num);
            A = 27'h4000000;
            B = 27'h2;

            #1;


            check_outputs(54'h8000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime-like large multiplication", test_num);
            A = 27'h7FFFFFB;
            B = 27'h3;



            #1;




            check_outputs(54'h17FFFFF1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symmetric multiplication", test_num);
            A = 27'h1234567;
            B = 27'h1234567;


            #1;



            check_outputs(54'h14B66DC3099E9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [53:0] expected_Y;
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
