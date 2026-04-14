`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    wire [7:0] I_interp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .I00(I00),
        .I01(I01),
        .I10(I10),
        .I11(I11),
        .I_interp(I_interp)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            I00 = 8'd0; I01 = 8'd0; I10 = 8'd0; I11 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Full Scale (All 255)", test_num);
            I00 = 8'd255; I01 = 8'd255; I10 = 8'd255; I11 = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Uniform Mid-range", test_num);
            I00 = 8'd128; I01 = 8'd128; I10 = 8'd128; I11 = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Perfect Average (Sum divisible by 4)", test_num);
            I00 = 8'd10; I01 = 8'd20; I10 = 8'd30; I11 = 8'd40;

            #1;


            check_outputs(8'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Truncation Check (Sum not divisible by 4)", test_num);
            I00 = 8'd255; I01 = 8'd0; I10 = 8'd0; I11 = 8'd0;

            #1;


            check_outputs(8'd63);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Horizontal Gradient", test_num);
            I00 = 8'd200; I01 = 8'd200; I10 = 8'd0; I11 = 8'd0;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Mixed High and Low Values", test_num);
            I00 = 8'd250; I01 = 8'd10; I10 = 8'd250; I11 = 8'd10;

            #1;


            check_outputs(8'd130);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interpolation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_I_interp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I_interp === (expected_I_interp ^ I_interp ^ expected_I_interp)) begin
                $display("PASS");
                $display("  Outputs: I_interp=%h",
                         I_interp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_interp=%h",
                         expected_I_interp);
                $display("  Got:      I_interp=%h",
                         I_interp);
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
