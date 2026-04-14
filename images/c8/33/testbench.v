`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] E;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            A = 8'd0;
            B = 8'd0;
            C = 8'd0;
            D = 8'd0;
            E = 8'd0;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple small values", test_num);
            A = 8'd2;
            B = 8'd3;
            C = 8'd4;
            D = 8'd5;
            E = 8'd6;

            #1;


            check_outputs(16'd126);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A*B at max 8-bit, CDE zero", test_num);
            A = 8'd255;
            B = 8'd255;
            C = 8'd0;
            D = 8'd0;
            E = 8'd0;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C*D*E larger than 16-bit (Truncation Check)", test_num);
            A = 8'd0;
            B = 8'd0;
            C = 8'd100;
            D = 8'd100;
            E = 8'd100;


            #1;



            check_outputs(16'h4240);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed large values within 16-bit range", test_num);
            A = 8'd100;
            B = 8'd50;
            C = 8'd20;
            D = 8'd10;
            E = 8'd5;

            #1;


            check_outputs(16'd6000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result near 16-bit boundary", test_num);
            A = 8'd10;
            B = 8'd10;
            C = 8'd255;
            D = 8'd255;
            E = 8'd1;

            #1;


            check_outputs(16'd65125);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            A = 8'd1;
            B = 8'd1;
            C = 8'd1;
            D = 8'd1;
            E = 8'd1;

            #1;


            check_outputs(16'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow on both terms", test_num);
            A = 8'd255;
            B = 8'd255;
            C = 8'd255;
            D = 8'd255;
            E = 8'd255;


            #1;



            check_outputs(16'h0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [15:0] expected_Y;
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
