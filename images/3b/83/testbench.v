`timescale 1ns/1ps

module rgb_to_yuv_tb;

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
    rgb_to_yuv dut (
        .B(B),
        .G(G),
        .R(R),
        .U(U),
        .V(V),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Black (0, 0, 0)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd0; B = 8'd0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: White (255, 255, 255)");
            test_num = test_num + 1;
            R = 8'd255; G = 8'd255; B = 8'd255;
            #1;

            check_outputs(8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pure Red (255, 0, 0)");
            test_num = test_num + 1;
            R = 8'd255; G = 8'd0; B = 8'd0;



            #1;




            check_outputs(8'hDA, 8'h9D, 8'h4C);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pure Green (0, 255, 0)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd255; B = 8'd0;



            #1;




            check_outputs(8'hB6, 8'h7D, 8'h96);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pure Blue (0, 0, 255)");
            test_num = test_num + 1;
            R = 8'd0; G = 8'd0; B = 8'd255;



            #1;




            check_outputs(8'h6F, 8'hE7, 8'h1D);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Mid-Gray (128, 128, 128)");
            test_num = test_num + 1;
            R = 8'd128; G = 8'd128; B = 8'd128;
            #1;

            check_outputs(8'h00, 8'h00, 8'h80);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Mixed Color (100, 150, 200)");
            test_num = test_num + 1;
            R = 8'd100; G = 8'd150; B = 8'd200;



            #1;




            check_outputs(8'h1D, 8'hDC, 8'h8D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rgb_to_yuv Testbench");
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
