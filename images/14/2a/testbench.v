`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] u;
    reg [7:0] v;
    wire [7:0] pixel_out;

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
        .u(u),
        .v(v),
        .pixel_out(pixel_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Corner A (u=0, v=0)", test_num);
            A = 8'd150; B = 8'd200; C = 8'd50; D = 8'd100;
            u = 8'd0; v = 8'd0;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform Image", test_num);
            A = 8'd100; B = 8'd100; C = 8'd100; D = 8'd100;
            u = 8'd128; v = 8'd128;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint Interpolation", test_num);
            A = 8'd0; B = 8'd200; C = 8'd0; D = 8'd200;
            u = 8'd128; v = 8'd128;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Gradient (u=255, v=0)", test_num);
            A = 8'd0; B = 8'd255; C = 8'd0; D = 8'd255;
            u = 8'd255; v = 8'd0;

            #1;


            check_outputs(8'd254);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Gradient (u=0, v=255)", test_num);
            A = 8'd0; B = 8'd0; C = 8'd255; D = 8'd255;
            u = 8'd0; v = 8'd255;

            #1;


            check_outputs(8'd254);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Corner D Influence (u=255, v=255)", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd255;
            u = 8'd255; v = 8'd255;

            #1;


            check_outputs(8'd252);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Weighted Interpolation", test_num);
            A = 8'd100; B = 8'd200; C = 8'd50; D = 8'd150;
            u = 8'd64; v = 8'd192;



            #1;




            check_outputs(8'd87);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Values", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd0;
            u = 8'd255; v = 8'd255;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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
