`timescale 1ns/1ps

module RGB_to_YUV_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] B;
    reg [7:0] G;
    reg [7:0] R;
    wire [7:0] U;
    wire [7:0] V;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RGB_to_YUV dut (
        .B(B),
        .G(G),
        .R(R),
        .U(U),
        .V(V),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Black (R=0, G=0, B=0)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd0; B = 8'd0;

            #1;


            check_outputs(8'h80, 8'h80, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: White (R=255, G=255, B=255)");
            test_num = test_num + 1;
            R = 8'd255; G = 8'd255; B = 8'd255;

            #1;


            check_outputs(8'h80, 8'h80, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Pure Red (R=255, G=0, B=0)");
            test_num = test_num + 1;
            R = 8'd255; G = 8'd0; B = 8'd0;



            #1;




            check_outputs(8'h5A, 8'hFF, 8'h4C);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Pure Green (R=0, G=255, B=0)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd255; B = 8'd0;



            #1;




            check_outputs(8'h36, 8'h00, 8'h96);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Pure Blue (R=0, G=0, B=255)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd0; B = 8'd255;



            #1;




            check_outputs(8'hEF, 8'h67, 8'h1D);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Medium Gray (R=128, G=128, B=128)");
            test_num = test_num + 1;
            R = 8'd128; G = 8'd128; B = 8'd128;

            #1;


            check_outputs(8'h80, 8'h80, 8'h80);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Yellow (R=255, G=255, B=0)");
            test_num = test_num + 1;
            R = 8'd255; G = 8'd255; B = 8'd0;

            #1;


            check_outputs(8'h11, 8'h9A, 8'hE2);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Cyan (R=0, G=255, B=255)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd255; B = 8'd255;


            #1;



            check_outputs(8'hA6, 8'h00, 8'hB3);
        end
        endtask

    task testcase009;

        begin
            $display("\nTestcase 009: Magenta (R=255, G=0, B=255)");
            test_num = test_num + 1;
            R = 8'd255; G = 8'd0; B = 8'd255;

            #1;


            check_outputs(8'hCA, 8'hFF, 8'h69);
        end
        endtask

    task testcase010;

        begin
            $display("\nTestcase 010: Custom Mix (R=100, G=150, B=200)");
            test_num = test_num + 1;
            R = 8'd100; G = 8'd150; B = 8'd200;

            #1;


            check_outputs(8'h9D, 8'h5C, 8'h8D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RGB_to_YUV Testbench");
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
        input [7:0] expected_U;
        input [7:0] expected_V;
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U === (expected_U ^ U ^ expected_U) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: U=%h, V=%h, Y=%h",
                         U, V, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U=%h, V=%h, Y=%h",
                         expected_U, expected_V, expected_Y);
                $display("  Got:      U=%h, V=%h, Y=%h",
                         U, V, Y);
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
