`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [15:0] max_val;
    reg [15:0] min_val;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .max_val(max_val),
        .min_val(min_val),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive value within range", test_num);
            data_in = 16'd500;
            max_val = 16'd1000;
            min_val = 16'd0;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive value exceeding max_val (Saturation High)", test_num);
            data_in = 16'd1500;
            max_val = 16'd1000;
            min_val = 16'd0;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive value below min_val (Saturation Low)", test_num);
            data_in = 16'd50;
            max_val = 16'd1000;
            min_val = 16'd100;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative value within range", test_num);
            data_in = -16'd200;
            max_val = 16'd500;
            min_val = -16'd1000;
            #1;

            check_outputs(-16'd200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative value exceeding min_val (Saturation Low)", test_num);
            data_in = -16'd2000;
            max_val = 16'd500;
            min_val = -16'd1000;
            #1;

            check_outputs(-16'd1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative value exceeding max_val (Saturation High)", test_num);
            data_in = -16'd50;
            max_val = -16'd100;
            min_val = -16'd500;
            #1;

            check_outputs(-16'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary condition - Exactly max_val", test_num);
            data_in = 16'h7FFF;
            max_val = 16'h7FFF;
            min_val = 16'h8000;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary condition - Exactly min_val", test_num);
            data_in = 16'h8000;
            max_val = 16'h7FFF;
            min_val = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input zero within range", test_num);
            data_in = 16'd0;
            max_val = 16'd10;
            min_val = -16'd10;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large range check", test_num);
            data_in = 16'h4000;
            max_val = 16'h3FFF;
            min_val = 16'hC000;
            #1;

            check_outputs(16'h3FFF);
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
