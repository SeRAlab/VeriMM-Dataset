`timescale 1ns/1ps

module cordic_sine_cosine_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] angle;
    wire [15:0] cosine;
    wire [15:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic_sine_cosine dut (
        .angle(angle),
        .cosine(cosine),
        .sine(sine)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle 0.0 rad", test_num);
            angle = 16'h0000;
            #1;

            check_outputs(16'h4000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle pi/2 rad", test_num);
            angle = 16'h3244;
            #1;

            check_outputs(16'h0000, 16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle -pi/2 rad", test_num);
            angle = 16'hCDBC;
            #1;

            check_outputs(16'h0000, 16'hC000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle pi/4 rad", test_num);
            angle = 16'h1922;
            #1;

            check_outputs(16'h2D41, 16'h2D41);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle -pi/4 rad", test_num);
            angle = 16'hE6DE;
            #1;

            check_outputs(16'h2D41, 16'hD2BF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle pi/3 rad", test_num);
            angle = 16'h2183;
            #1;

            check_outputs(16'h2000, 16'h376C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle pi/6 rad", test_num);
            angle = 16'h10C1;
            #1;

            check_outputs(16'h376C, 16'h2000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle pi rad", test_num);
            angle = 16'h6488;
            #1;

            check_outputs(16'hC000, 16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle -pi rad", test_num);
            angle = 16'h9B78;
            #1;

            check_outputs(16'hC000, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Angle 0.1 rad", test_num);
            angle = 16'h0333;
            #1;

            check_outputs(16'h3FB2, 16'h0663);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic_sine_cosine Testbench");
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
        input [15:0] expected_cosine;
        input [15:0] expected_sine;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cosine === (expected_cosine ^ cosine ^ expected_cosine) &&
                expected_sine === (expected_sine ^ sine ^ expected_sine)) begin
                $display("PASS");
                $display("  Outputs: cosine=%h, sine=%h",
                         cosine, sine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cosine=%h, sine=%h",
                         expected_cosine, expected_sine);
                $display("  Got:      cosine=%h, sine=%h",
                         cosine, sine);
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
