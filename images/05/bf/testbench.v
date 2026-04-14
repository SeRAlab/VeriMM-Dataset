`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] out;

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
        .x(x),
        .y(y),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Top-Left Corner (x=0, y=0)", test_num);
            A = 8'd150; B = 8'd20; C = 8'd20; D = 8'd20;
            x = 8'd0;   y = 8'd0;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Exact Center (x=128, y=128)", test_num);
            A = 8'd100; B = 8'd100; C = 8'd200; D = 8'd200;
            x = 8'd128; y = 8'd128;

            #1;


            check_outputs(8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Uniform Input Values", test_num);
            A = 8'd77;  B = 8'd77;  C = 8'd77;  D = 8'd77;
            x = 8'd45;  y = 8'd180;
            #1;

            check_outputs(8'd77);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Horizontal Mid-point (y=0)", test_num);
            A = 8'd0;   B = 8'd200; C = 8'd50;  D = 8'd50;
            x = 8'd128; y = 8'd0;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Vertical Weighting (Quarter Down)", test_num);
            A = 8'd0;   B = 8'd0;   C = 8'd200; D = 8'd200;
            x = 8'd0;   y = 8'd64;

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multi-pixel Weighted Blend", test_num);
            A = 8'd10;  B = 8'd20;  C = 8'd30;  D = 8'd40;
            x = 8'd128; y = 8'd128;

            #1;


            check_outputs(8'd25);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Near Bottom-Right Corner (x=255, y=255)", test_num);
            A = 8'd0;   B = 8'd0;   C = 8'd0;   D = 8'd255;
            x = 8'd255; y = 8'd255;

            #1;


            check_outputs(8'd253);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
