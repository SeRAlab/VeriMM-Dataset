`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x(x),
        .y(y)
    );
    task reset_filter;

        begin
            x = 0;
            repeat(5) #10;
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Zero Input");
            test_num = 1;
            reset_filter();
            x = 0; #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Impulse Response (Coeff 4 Tail)");
            test_num = 2;
            reset_filter();



            x = 5'd1; #10;
            x = 5'd0; #10;
            x = 5'd0; #10;
            x = 5'd0; #10;
            x = 5'd0;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: DC Step Response (Low Value)");
            test_num = 3;
            reset_filter();


            x = 5'd2; #10;
            x = 5'd2; #10;
            x = 5'd2; #10;
            x = 5'd2; #10;
            x = 5'd2;
            #1;

            check_outputs(5'd18);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: DC Step Response (Overflow Check)");
            test_num = 4;
            reset_filter();



            x = 5'd31; #10;
            x = 5'd31; #10;
            x = 5'd31; #10;
            x = 5'd31; #10;
            x = 5'd31;
            #1;

            check_outputs(5'd23);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Linear Ramp Input");
            test_num = 5;
            reset_filter();


            x = 5'd1; #10;
            x = 5'd2; #10;
            x = 5'd3; #10;
            x = 5'd4; #10;
            x = 5'd5;
            #1;

            check_outputs(5'd27);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Alternating High/Low Input");
            test_num = 6;
            reset_filter();



            x = 5'd10; #10;
            x = 5'd20; #10;
            x = 5'd10; #10;
            x = 5'd20; #10;
            x = 5'd10;
            #1;

            check_outputs(5'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
