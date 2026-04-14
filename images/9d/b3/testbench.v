`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] H;
    reg [7:0] S;
    reg [7:0] V;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .H(H),
        .S(S),
        .V(V),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            H = 9'd75;
            S = 8'd150;
            V = 8'd150;
            #10;
            $display("Test %0d: Mid-range values (In-range)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            H = 9'd25;
            S = 8'd150;
            V = 8'd150;
            #10;
            $display("Test %0d: Hue below range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            H = 9'd125;
            S = 8'd150;
            V = 8'd150;
            #10;
            $display("Test %0d: Hue above range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            H = 9'd75;
            S = 8'd50;
            V = 8'd150;
            #10;
            $display("Test %0d: Saturation below range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            H = 9'd75;
            S = 8'd220;
            V = 8'd150;
            #10;
            $display("Test %0d: Saturation above range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            H = 9'd75;
            S = 8'd150;
            V = 8'd50;
            #10;
            $display("Test %0d: Value below range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            H = 9'd75;
            S = 8'd150;
            V = 8'd220;
            #10;
            $display("Test %0d: Value above range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            H = 9'd50;
            S = 8'd100;
            V = 8'd100;
            #10;
            $display("Test %0d: Exact lower boundary check", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            H = 9'd100;
            S = 8'd200;
            V = 8'd200;
            #10;
            $display("Test %0d: Exact upper boundary check", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            H = 9'd0;
            S = 8'd0;
            V = 8'd0;
            #10;
            $display("Test %0d: All zeros check", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            H = 9'd300;
            S = 8'd20;
            V = 8'd255;
            #10;
            $display("Test %0d: Multiple components out of range", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            H = 9'd75;
            S = 8'd0;
            V = 8'd0;
            #10;
            $display("Test %0d: Partial match check", test_num);
            #1;

            check_outputs(1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
