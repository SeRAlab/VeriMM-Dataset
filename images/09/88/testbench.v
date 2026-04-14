`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] X;
    reg [7:0] Y;
    wire [7:0] interpolated_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .X(X),
        .Y(Y),
        .interpolated_value(interpolated_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Corner A (X=0, Y=0)", test_num);
            A = 8'd50; B = 8'd100; C = 8'd150; D = 8'd200;
            X = 8'd0; Y = 8'd0;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Uniform Field", test_num);
            A = 8'd128; B = 8'd128; C = 8'd128; D = 8'd128;
            X = 8'd200; Y = 8'd55;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Midpoint (X=128, Y=0)", test_num);
            A = 8'd100; B = 8'd200; C = 8'd0; D = 8'd0;
            X = 8'd128; Y = 8'd0;

            #1;


            check_outputs(8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Midpoint (X=0, Y=128)", test_num);
            A = 8'd40; B = 8'd0; C = 8'd140; D = 8'd0;
            X = 8'd0; Y = 8'd128;

            #1;


            check_outputs(8'd90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Center Point (X=128, Y=128)", test_num);
            A = 8'd10; B = 8'd20; C = 8'd30; D = 8'd40;
            X = 8'd128; Y = 8'd128;

            #1;


            check_outputs(8'd25);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Near B (X=255, Y=0)", test_num);
            A = 8'd10; B = 8'd200; C = 8'd50; D = 8'd50;
            X = 8'd255; Y = 8'd0;


            #1;



            check_outputs(8'd199);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Arbitrary Interpolation", test_num);
            A = 8'd0; B = 8'd255; C = 8'd0; D = 8'd255;
            X = 8'd64; Y = 8'd128;


            #1;



            check_outputs(8'd63);
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
        input [7:0] expected_interpolated_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_interpolated_value === (expected_interpolated_value ^ interpolated_value ^ expected_interpolated_value)) begin
                $display("PASS");
                $display("  Outputs: interpolated_value=%h",
                         interpolated_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interpolated_value=%h",
                         expected_interpolated_value);
                $display("  Got:      interpolated_value=%h",
                         interpolated_value);
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
