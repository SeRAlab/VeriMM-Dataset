`timescale 1ns/1ps

module data_mask_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [1:0] mask_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_mask dut (
        .data_in(data_in),
        .mask_in(mask_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=0 (Passthrough)", test_num);
            data_in = 8'hA5;
            mask_in = 2'd0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=1 (Shift Down, Upper 4-bits 0)", test_num);
            data_in = 8'hB4;
            mask_in = 2'd1;

            #1;


            check_outputs(8'h0B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=2 (Shift Up, Lower 4-bits 0)", test_num);
            data_in = 8'h3C;
            mask_in = 2'd2;

            #1;


            check_outputs(8'hC0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=3 (Bitwise AND with 0xF0)", test_num);
            data_in = 8'hDE;
            mask_in = 2'd3;

            #1;


            check_outputs(8'hD0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=1 (Boundary check all 1s)", test_num);
            data_in = 8'hFF;
            mask_in = 2'd1;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=2 (Boundary check all 1s)", test_num);
            data_in = 8'hFF;
            mask_in = 2'd2;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=0 (Zero input)", test_num);
            data_in = 8'h00;
            mask_in = 2'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=3 (Zero input)", test_num);
            data_in = 8'h00;
            mask_in = 2'd3;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=1 (Alternating bits)", test_num);
            data_in = 8'h55;
            mask_in = 2'd1;

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: mask_in=2 (Alternating bits)", test_num);
            data_in = 8'hAA;
            mask_in = 2'd2;

            #1;


            check_outputs(8'hA0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_mask Testbench");
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
        input [7:0] expected_data_out;
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
