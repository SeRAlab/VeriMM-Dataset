`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [5:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 4'b0000;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 4'b0001;
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 4'b0010;
        #1;

        check_outputs(6'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 4'b0100;
        #1;

        check_outputs(6'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 4'b1000;
        #1;

        check_outputs(6'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 4'b0011;
        #1;

        check_outputs(6'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 4'b0101;
        #1;

        check_outputs(6'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 4'b1010;
        #1;

        check_outputs(6'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 4'b1100;
        #1;

        check_outputs(6'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 4'b1111;
        #1;

        check_outputs(6'd10);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        x = 4'b1011;
        #1;

        check_outputs(6'd7);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        x = 4'b0111;
        #1;

        check_outputs(6'd6);
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
        input [5:0] expected_y;
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
