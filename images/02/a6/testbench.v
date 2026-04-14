`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I1;
    reg [7:0] I2;
    reg [7:0] I3;
    reg [7:0] I4;
    reg [7:0] I5;
    reg [7:0] I6;
    reg [7:0] I7;
    reg [7:0] I8;
    reg [7:0] I9;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .I6(I6),
        .I7(I7),
        .I8(I8),
        .I9(I9),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            I1 = 8'd0; I2 = 8'd0; I3 = 8'd0;
            I4 = 8'd0; I5 = 8'd0; I6 = 8'd0;
            I7 = 8'd0; I8 = 8'd0; I9 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Max Value (255)", test_num);
            I1 = 8'd255; I2 = 8'd255; I3 = 8'd255;
            I4 = 8'd255; I5 = 8'd255; I6 = 8'd255;
            I7 = 8'd255; I8 = 8'd255; I9 = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Center Impulse (I5=128)", test_num);
            I1 = 8'd0;   I2 = 8'd0;   I3 = 8'd0;
            I4 = 8'd0;   I5 = 8'd128; I6 = 8'd0;
            I7 = 8'd0;   I8 = 8'd0;   I9 = 8'd0;

            #1;


            check_outputs(8'd32);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Corner Impulse (I1=128)", test_num);
            I1 = 8'd128; I2 = 8'd0;   I3 = 8'd0;
            I4 = 8'd0;   I5 = 8'd0;   I6 = 8'd0;
            I7 = 8'd0;   I8 = 8'd0;   I9 = 8'd0;

            #1;


            check_outputs(8'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Edge Impulse (I2=128)", test_num);
            I1 = 8'd0;   I2 = 8'd128; I3 = 8'd0;
            I4 = 8'd0;   I5 = 8'd0;   I6 = 8'd0;
            I7 = 8'd0;   I8 = 8'd0;   I9 = 8'd0;

            #1;


            check_outputs(8'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Grey (128)", test_num);
            I1 = 8'd128; I2 = 8'd128; I3 = 8'd128;
            I4 = 8'd128; I5 = 8'd128; I6 = 8'd128;
            I7 = 8'd128; I8 = 8'd128; I9 = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Line", test_num);
            I1 = 8'd0;   I2 = 8'd0;   I3 = 8'd0;
            I4 = 8'd160; I5 = 8'd160; I6 = 8'd160;
            I7 = 8'd0;   I8 = 8'd0;   I9 = 8'd0;


            #1;



            check_outputs(8'd80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Line", test_num);
            I1 = 8'd0; I2 = 8'd160; I3 = 8'd0;
            I4 = 8'd0; I5 = 8'd160; I6 = 8'd0;
            I7 = 8'd0; I8 = 8'd160; I9 = 8'd0;


            #1;



            check_outputs(8'd80);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checkerboard Pattern", test_num);
            I1 = 8'd255; I2 = 8'd0;   I3 = 8'd255;
            I4 = 8'd0;   I5 = 8'd255; I6 = 8'd0;
            I7 = 8'd255; I8 = 8'd0;   I9 = 8'd255;


            #1;



            check_outputs(8'd127);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Sequence", test_num);
            I1 = 8'd10; I2 = 8'd20; I3 = 8'd30;
            I4 = 8'd40; I5 = 8'd50; I6 = 8'd60;
            I7 = 8'd70; I8 = 8'd80; I9 = 8'd90;



            #1;




            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gaussian_blur Testbench");
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
        input [7:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
